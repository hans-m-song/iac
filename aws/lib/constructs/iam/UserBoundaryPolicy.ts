import {
  Effect,
  ManagedPolicy,
  ManagedPolicyProps,
  PolicyStatement,
} from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

export class UserBoundaryPolicy extends ManagedPolicy {
  constructor(scope: Construct, id: string, props?: ManagedPolicyProps) {
    super(scope, id, props);

    // cloudformation
    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "cloudformation:DescribeStacks",
          "cloudformation:ExecuteChangeSet",
          "cloudformation:DescribeChangeSet",
          "cloudformation:GetTemplateSummary",
          "cloudformation:ListStacks",
          "cloudformation:CreateChangeSet",
          "cloudformation:DescribeStackEvents",
        ],
        resources: ["*"],
      }),
      new PolicyStatement({
        effect: Effect.DENY,
        actions: ["cloudformation:CreateStack"],
        resources: ["*"],
        conditions: {
          "ForAnyValue:StringLikeIfExists": {
            "cloudformation:ResourceTypes": [
              "AWS::IAM::AccessKey",
              "AWS::IAM::Group",
              "AWS::IAM::InstanceProfile",
              "AWS::IAM::SAMLProvider",
              "AWS::IAM::ServerCertificate",
              "AWS::IAM::User",
              "AWS::IAM::UserToGroupAddition",
              "AWS::IAM::VirtualMFADevice",
            ],
          },
        },
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

    // ecr
    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "ecr-public:DescribeImages",
          "ecr-public:DescribeRegistries",
          "ecr-public:DescribeRepositories",
          "ecr-public:GetAuthorizationToken",
        ],
        resources: ["*"],
      }),
    );

    // iam
    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["iam:ListAccountAliases"],
        resources: ["*"],
      }),
    );

    // sts
    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["sts:GetCallerIdentity", "sts:AssumeRole"],
        resources: ["*"],
      }),
    );

    // ssm
    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["ssm:GetParameter*"],
        resources: ["*"],
      }),
    );
  }
}
