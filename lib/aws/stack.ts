import { cliStream, cliSync } from "@lib/core/process.js";
import {
  CloudFormationClient,
  DeleteStackCommand,
  DescribeStacksCommand,
  CreateChangeSetCommand,
  ExecuteChangeSetCommand,
  CreateStackCommand,
  Stack as CloudformationStack,
  DescribeChangeSetCommand,
  DescribeChangeSetCommandOutput,
} from "@aws-sdk/client-cloudformation";
import { pollToTimeout } from "@lib/core/async.js";
import { renderTable } from "@lib/core/table.js";
import { table } from "table";

const client = new CloudFormationClient({});

export class Stack {
  filepath: string;
  name: string;
  outputDir: string;
  outputTemplate: string;

  constructor(props: { filepath: string; name: string }) {
    this.filepath = props.filepath;
    this.name = props.name;
    this.outputDir = `cdk.out/${this.name}`;
    this.outputTemplate = `file://${this.outputDir}/${this.name}.template.json`;
  }

  async describe() {
    const command = new DescribeStacksCommand({ StackName: this.name });
    try {
      const response = await client.send(command);
      const stack = response.Stacks?.find(
        (stack) => stack.StackName === this.name,
      );
      return stack ?? null;
    } catch (error: any) {
      if (error?.message?.endsWith?.("does not exist")) {
        return null;
      }

      throw error;
    }
  }

  async synth() {
    await cliSync(
      `npx`,
      `cdk`,
      `synth`,
      `--app="npx tsx ${this.filepath}"`,
      `--output="${this.outputDir}"`,
      `--quiet`,
    );
  }

  async create(timeout?: number) {
    const command = new CreateStackCommand({
      StackName: this.name,
      Capabilities: ["CAPABILITY_NAMED_IAM"],
      TemplateURL: this.outputTemplate,
    });

    const response = await client.send(command);

    await pollToTimeout(
      async () => {
        const stack = await this.describe();
        console.log("stack status is", stack?.StackStatus);
        return stack;
      },
      (stack) => stack?.StackStatus !== "CREATE_IN_PROGRESS",
      timeout,
    );

    return response.StackId;
  }

  async deploy() {
    await cliStream(
      "npx",
      "cdk",
      "deploy",
      `--app="${this.outputDir}"`,
      `--quiet`,
    );
  }

  async destroy() {
    await cliStream(
      "npx",
      "cdk",
      "destroy",
      `--app="${this.outputDir}"`,
      `--quiet`,
    );
  }

  async update(timeout?: number) {
    const createCmd = new CreateChangeSetCommand({
      StackName: this.name,
      ChangeSetName: `${this.name}-${Date.now()}`,
      Capabilities: ["CAPABILITY_NAMED_IAM"],
      TemplateURL: this.outputTemplate,
    });

    const createRes = await client.send(createCmd);
    console.log(createRes);

    let status: string | undefined;
    const poll = (until: (output: DescribeChangeSetCommandOutput) => boolean) =>
      pollToTimeout(
        async () => {
          const command = new DescribeChangeSetCommand({
            StackName: this.name,
            ChangeSetName: createRes.Id,
          });

          const output = await client.send(command);
          if (output.Status) {
            status = output.Status;
            console.log("changeset status is", output.Status);
          }

          return output;
        },
        until,
        timeout,
      );

    // wait for create complete
    await poll((cs) => !cs.Status?.includes("PROGRESS"));
    if (status !== "CREATE_COMPLETE") {
      throw new Error(`Changeset creation failed, status is: "${status}"`);
    }

    const executeCmd = new ExecuteChangeSetCommand({
      StackName: this.name,
      ChangeSetName: createRes.Id,
    });

    const executeRes = await client.send(executeCmd);
    console.log(executeRes);
    await poll((cs) => !cs.Status?.includes("PROGRESS"));
  }

  async delete(timeout?: number) {
    const command = new DeleteStackCommand({ StackName: this.name });
    await client.send(command);

    await pollToTimeout(
      async () => {
        const stack = await this.describe();
        console.log("stack status is", stack?.StackStatus);
        return stack;
      },
      (stack) => stack?.StackStatus !== "DELETE_IN_PROGRESS",
      timeout,
    );
  }

  // TODO do i need this?
  // static async import() {
  //   const raw = await fs.readFile(this.outputTemplate);
  //   return JSON.parse(raw.toString());
  // }

  static tabulate(spec: CloudformationStack) {
    return renderTable("Stack details", {
      "id": spec.StackId,
      "name": spec.StackName,
      "parameters": spec.Parameters?.map((p) =>
        table(
          Object.entries({
            key: p.ParameterKey,
            value: p.ParameterValue,
            resolved: p.ResolvedValue,
          }),
        ),
      ),
      "creation": spec.CreationTime,
      "last updated": spec.LastUpdatedTime,
      "capabilities": spec.Capabilities?.join("\n"),
      "deployed by": spec.RoleARN,
    });
  }
}
