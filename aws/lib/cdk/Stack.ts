import { CfnOutput, Stack as CDKStack, StackProps, Tags } from "aws-cdk-lib";
import { Construct } from "constructs";

import { getContext } from "./context";

export class Stack extends CDKStack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    const context = getContext(scope);
    const stackName = props?.stackName ?? id;

    super(scope, id, {
      ...props,
      stackName,
      tags: {
        StackName: stackName,
        GitRepository: context.repositoryUrl,
        Purpose: "Infrastructure",
        ...props?.tags,
      },
    });
  }

  tag() {
    Object.entries(this.tags.tagValues()).forEach(([name, value]) => {
      Tags.of(this).add(name, value);
    });
  }

  output(name: string, value: string) {
    return new CfnOutput(this, name, { value });
  }
}
