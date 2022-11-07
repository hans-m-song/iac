import { Arn, aws_iam, Stack } from "aws-cdk-lib";
import { Construct } from "constructs";

export class DefaultBoundaryPolicy extends aws_iam.ManagedPolicy {
  constructor(scope: Construct) {
    super(scope, `${scope.node.id}-Default`, {
      description: "Default boundary policy",
      statements: [
        new aws_iam.PolicyStatement({
          actions: [
            "iam:CreateAccessKey",
            "iam:CreateAccountAlias",
            "iam:CreateGroup",
            "iam:CreateInstanceProfile",
            "iam:CreateLoginProfile",
            "iam:CreateOpenIDConnectProvider",
            // "iam:CreateRole",
            "iam:CreateSAMLProvider",
            "iam:CreateServiceLinkedRole",
            "iam:CreateServiceSpecificCredential",
            // "iam:CreatePolicy",
            "iam:CreatePolicyVersion",
            "iam:CreateUser",
            "iam:CreateVirtualMFADevice",
          ],
          effect: aws_iam.Effect.DENY,
          resources: ["*"],
        }),
        new aws_iam.PolicyStatement({
          actions: ["sts:AssumeRole"],
          effect: aws_iam.Effect.ALLOW,
          resources: [
            Arn.format({
              partition: "aws",
              region: "",
              service: "iam",
              account: Stack.of(scope).account,
              resource: "role",
              resourceName: "cdk-*",
            }),
          ],
        }),
        new aws_iam.PolicyStatement({
          actions: [
            "apigateway:*",
            "cloudformation:*",
            "cloudfront:*",
            "cloudwatch:*",
            "dynamodb:*",
            "ecr-public:*",
            "iam:*",
            "lambda:*",
            "route53:*",
            "s3:*",
            "ssm:*",
          ],
          effect: aws_iam.Effect.ALLOW,
          resources: ["*"],
        }),
      ],
    });
  }
}
