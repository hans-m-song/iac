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
          "ecr:*",
          "execute-api:*",
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
        effect: Effect.ALLOW,
        actions: [
          "iam:ListOpenIDConnectProviderTags",
          "iam:ListPolicyTags",
          "iam:ListRoleTags",
          "iam:TagOpenIDConnectProvider",
          "iam:TagPolicy",
          "iam:TagRole",
          "iam:UntagOpenIDConnectProvider",
          "iam:UntagPolicy",
          "iam:UntagRole",
        ],
        resources: ["*"],
      }),
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "iam:GetRole",
          "iam:DeleteRole",
          // "iam:DeleteRolePermissionsBoundary",
          "iam:DeleteRolePolicy",
          "iam:DetachRolePolicy",
        ],
        resources: ["*"],
      }),
      new PolicyStatement({
        effect: Effect.DENY,
        actions: [
          "iam:AttachRolePolicy",
          "iam:CreateRole",
          "iam:PutRolePolicy",
          "iam:PutRolePermissionsBoundary",
        ],
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
