import { App, aws_ssm, CfnOutput, Stack, Tags } from "aws-cdk-lib";
import { HostedZoneUpdatePolicy } from "@resources/iam/Policy-Route53-HostedZoneUpdate.js";
import { getContext } from "@lib/aws/context.js";

const app = new App();
const stack = new Stack(app, "HostedZoneUpdate");

const policy = new HostedZoneUpdatePolicy(stack, [
  { name: "HsongMe", id: "Z09233301OJXCBONJC133" },
  { name: "AxatolXyz", id: "Z067173715955IHMKKU3W" },
]);

new aws_ssm.StringParameter(stack, "HostedZoneUpdatePolicyARN", {
  parameterName: "/hosted-zone-update/policy/arn",
  stringValue: policy.managedPolicyArn,
  description: `ARN for managed policy ${policy.managedPolicyName}`,
});

console.log(getContext(stack));
Tags.of(app).add("Stack", stack.stackName);
