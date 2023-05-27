import {
  Effect,
  ManagedPolicy,
  ManagedPolicyProps,
  PolicyStatement,
} from "aws-cdk-lib/aws-iam";
import { StringParameter } from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { SSM } from "~/lib/constants";

export class CloudFormationExecutionPolicy extends ManagedPolicy {
  constructor(scope: Construct, id: string, props?: ManagedPolicyProps) {
    super(scope, id, props);

    // wildcard access
    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "apigateway:*",
          "cloudfront:*",
          "cloudwatch:*",
          "lambda:*",
          "s3:*",
        ],
        resources: ["*"],
      }),
    );

    // ec2
    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["ec2:DescribeRegions"],
        resources: ["*"],
      }),
    );

    // iam
    this.addStatements(
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
          "iam:AttachRolePolicy",
          "iam:CreateRole",
          "iam:PutRolePolicy",
          "iam:PutRolePermissionsBoundary",
        ],
        resources: ["*"],
        conditions: {
          "ForAnyValue:StringEquals": {
            "iam:PermissionsBoundary": [SSM.LambdaBoundaryPolicyARN].map(
              (arn) => StringParameter.valueForStringParameter(this, arn),
            ),
          },
        },
      }),
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["iam:PassRole"],
        resources: ["*"],
        conditions: {
          StringEquals: { "iam:PassedToService": "states.amazonaws.com" },
        },
      }),
    );

    // ssm
    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "ssm:AddTagsToResource",
          "ssm:DeleteParameter",
          "ssm:GetParameters",
          "ssm:LabelParameterVersion",
          "ssm:ListTagsForResource",
          "ssm:PutParameter",
          "ssm:RemoveTagsFromResource",
        ],
        resources: ["*"],
      }),
    );

    // route53
    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["route53:ChangeResourceRecordSets"],
        resources: ["*"],
      }),
    );
  }
}
