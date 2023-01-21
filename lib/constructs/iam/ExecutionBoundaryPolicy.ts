import {
  Effect,
  ManagedPolicy,
  ManagedPolicyProps,
  PolicyStatement,
} from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { arn } from "~/lib/utils/arn";

export class ExecutionBoundaryPolicy extends ManagedPolicy {
  constructor(scope: Construct, id: string, props?: ManagedPolicyProps) {
    super(scope, id, props);

    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        resources: ["*"],
      }),
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["ssm:GetParameter*"],
        resources: [
          arn(this).parameter("infrastructure/*"),
          arn(this).parameter("execution/*"),
        ],
      }),
    );
  }
}
