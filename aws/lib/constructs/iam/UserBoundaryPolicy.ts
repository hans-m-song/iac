import {
  Effect,
  ManagedPolicy,
  ManagedPolicyProps,
  PolicyStatement,
} from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { ExecutionBoundaryPolicy } from "./ExecutionBoundaryPolicy";

import { arn } from "~/lib/utils/arn";

export interface UserBoundaryPolicyProps extends ManagedPolicyProps {
  executionBoundaryPolicy: ExecutionBoundaryPolicy;
}

export class UserBoundaryPolicy extends ManagedPolicy {
  constructor(
    scope: Construct,
    id: string,
    { executionBoundaryPolicy, ...props }: UserBoundaryPolicyProps,
  ) {
    super(scope, id, props);

    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "iam:AttachRolePolicy",
          "iam:CreateRole",
          "iam:PutRolePolicy",
          "iam:PutRolePermissionsBoundary",
        ],
        resources: ["*"],
        conditions: {
          "ForAnyValue:StringEquals": {
            "iam:PermissionsBoundary": [
              executionBoundaryPolicy.managedPolicyArn,
            ],
          },
        },
      }),
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "iam:DeleteRole",
          "iam:DeleteRolePermissionsBoundary",
          "iam:DeleteRolePolicy",
          "iam:DetachRolePolicy",
        ],
        resources: ["*"],
      }),
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "ssm:AddTagsToResource",
          "ssm:DeleteParameter*",
          "ssm:GetParameter*",
          "ssm:LabelParameterVersion",
          "ssm:ListTagsForResource",
          "ssm:PutParameter",
          "ssm:RemoveTagsFromResource",
        ],
        resources: [
          arn(this).parameter("infrastructure/*"),
          arn(this).parameter("execution/*"),
          arn(this).parameter("user/*"),
        ],
      }),
    );
  }
}
