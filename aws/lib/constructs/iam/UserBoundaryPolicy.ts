import {
  Effect,
  ManagedPolicy,
  ManagedPolicyProps,
  PolicyStatement,
} from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { ExecutionBoundaryPolicy } from "./ExecutionBoundaryPolicy";

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
          "apigateway:*",
          "cloudformation:*",
          "cloudfront:*",
          "cloudtrail:*",
          "cloudwatch:*",
          "dynamodb:*",
          "ecr-public:*",
          "execute-api:*",
          "iam:*",
          "lambda:*",
          "logs:*",
          "route53:*",
          "s3:*",
          "ses:*",
          "sns:*",
          "sqs:*",
          "ssm:*",
          "sts:*",
          "tag:*",
        ],
        resources: ["*"],
      }),
    );

    this.addStatements(
      new PolicyStatement({
        effect: Effect.DENY,
        actions: [
          "iam:CreateAccessKey",
          "iam:CreateVirtualMFADevice",
          "iam:DeactivateMFADevice",
          "iam:DeleteAccessKey",
          "iam:DeleteAccountPasswordPolicy",
        ],
        resources: ["*"],
      }),
      new PolicyStatement({
        effect: Effect.DENY,
        actions: ["iam:CreateUser", "iam:DeleteUser"],
        resources: ["*"],
        conditions: {
          "ForAnyValue:StringEquals": {
            "iam:PermissionsBoundary": this.managedPolicyArn,
          },
        },
      }),
      new PolicyStatement({
        effect: Effect.DENY,
        actions: ["iam:CreateRole", "iam:DeleteRole"],
        resources: ["*"],
        conditions: {
          "ForAnyValue:StringEquals": {
            "iam:PermissionsBoundary": executionBoundaryPolicy.managedPolicyArn,
          },
        },
      }),
    );
  }
}
