import "source-map-support/register";
import path from "path";
import { walk } from "@lib/core/fs.js";
import { promptIndex, promptYesNo } from "@lib/core/prompt.js";
import { renderTable } from "@lib/core/table.js";
import { Stack } from "@lib/aws/stack.js";

const args = process.argv.slice(2);
const debugEnabled = process.env.DEBUG === "true";
const debug = debugEnabled
  ? (...args: any[]) => console.log("[DEBUG]", ...args)
  : () => {};
debug("debug mode enabled");
const [givenStackName, givenAction, ...restArgs] = args;

console.log("Listing available stacks...");
const stackdir = path.join(process.cwd(), "./stacks");
const contents = await walk(stackdir);
debug({ contents: contents.map((item) => item.filepath) });
const items = contents
  .filter((item) => !item.filepath.endsWith("index.ts"))
  .map((item) => ({
    ...item,
    name: item.filepath.replace(`${stackdir}/`, "").replace(/\.ts$/, ""),
  }));

if (items.length < 1) {
  console.error("No stacks available in", stackdir);
  process.exit(1);
}

debug({ givenStackName });
if (givenStackName && !items.find((item) => item.name === givenStackName)) {
  console.error("Given stack name did not match found stacks");
  process.exit(1);
}

const givenStackIndex = items.findIndex((item) => item.name === givenStackName);
debug({ givenStackIndex });
if (givenStackIndex < 0) {
  console.log(
    renderTable(
      "Available stacks",
      items.map((item) => item.name),
    ),
  );
}

const stackIndex =
  givenStackIndex > -1
    ? givenStackIndex
    : await promptIndex("Select a stack", items.length - 1);
debug({ stackIndex });
const stack = new Stack(items[stackIndex]);

const exists = await stack.describe();
if (exists) {
  console.log("Notice: selected stack exists");
}

const actions = exists
  ? ["synth", "describe", "deploy", "destroy", "delete", "diff"]
  : ["synth", "describe", "deploy"];
debug({ givenAction });
if (givenAction && !actions.includes(givenAction)) {
  console.error(
    "Given action does not match available actions:",
    `[${actions.join(", ")}]`,
  );
  process.exit(1);
}

if (!givenAction) {
  console.log(renderTable("Actions", actions));
}

const actionIndex = givenAction
  ? actions.indexOf(givenAction)
  : await promptIndex("Select an action", actions.length - 1);
const action = actions[actionIndex];
debug({ actionIndex, action });

const executionArgs = debugEnabled
  ? [...restArgs, "--debug", "--verbose"]
  : restArgs;
switch (action) {
  // TODO via AWS SDK?
  // case "update":
  // case "create":
  // case "delete":

  case "diff": {
    console.log("Beginning synth...");
    await stack.synth(executionArgs);

    await stack.diff();
    break;
  }

  case "describe": {
    const spec = await stack.describe();
    if (!spec) {
      console.log("stack has not yet been deployed");
      break;
    }

    console.log(Stack.tabulate(spec));
    break;
  }

  case "synth": {
    console.log("Beginning synth...");
    await stack.synth(executionArgs);
    break;
  }

  case "deploy": {
    console.log("Beginning synth...");
    await stack.synth(executionArgs);

    await stack.diff();
    const shouldContinue = await promptYesNo("Continue?");
    if (!shouldContinue) {
      break;
    }

    console.log(`Beginning deploy...`);
    await stack.deploy(executionArgs);
    break;
  }

  case "destroy": {
    console.log("Beginning destroy...");
    await stack.destroy(executionArgs);
    break;
  }
}

process.exit(0);
