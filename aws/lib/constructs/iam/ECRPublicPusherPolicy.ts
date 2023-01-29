import { CfnPublicRepository } from "aws-cdk-lib/aws-ecr";
import {
  Effect,
  ManagedPolicy,
  ManagedPolicyProps,
  PolicyStatement,
} from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

export interface ECRPublicPusherPolicyProps extends ManagedPolicyProps {
  repositories: CfnPublicRepository[];
}

export class ECRPublicPusherPolicy extends ManagedPolicy {
  constructor(
    scope: Construct,
    id: string,
    { repositories, ...props }: ECRPublicPusherPolicyProps,
  ) {
    super(scope, id, props);

    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "sts:GetServiceBearerToken",
          "ecr-public:GetAuthorizationToken",
        ],
        resources: ["*"],
      }),
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "ecr-public:BatchCheckLayerAvailability",
          "ecr-public:GetRepositoryPolicy",
          "ecr-public:DescribeRepositories",
          "ecr-public:DescribeRegistries",
          "ecr-public:DescribeImages",
          "ecr-public:DescribeImageTags",
          "ecr-public:GetRepositoryCatalogData",
          "ecr-public:GetRegistryCatalogData",
        ],
        resources: ["*"],
      }),
    );

    if (repositories.length > 0) {
      this.addStatements(
        new PolicyStatement({
          effect: Effect.ALLOW,
          actions: [
            "ecr-public:BatchDeleteImage",
            "ecr-public:CompleteLayerUpload",
            "ecr-public:InitiateLayerUpload",
            "ecr-public:PutImage",
            "ecr-public:TagResource",
            "ecr-public:UntagResource",
            "ecr-public:UploadLayerPart",
          ],
          resources: repositories.map((repo) => repo.attrArn),
        }),
      );
    }
  }
}
