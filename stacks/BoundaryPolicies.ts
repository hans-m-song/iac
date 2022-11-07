import { Outputs } from "@resources/cloudformation/Output.js";
import { DefaultBoundaryPolicy } from "@resources/iam/Policy-BoundaryPolicies.js";
import { App, Stack, Tags } from "aws-cdk-lib";

const app = new App();
const stack = new Stack(app, "BoundaryPolicies");

const policy = new DefaultBoundaryPolicy(stack);

new Outputs(stack, { DefaultBoundaryPolicyARN: policy.managedPolicyArn });

Tags.of(app).add("Stack", stack.stackName);
