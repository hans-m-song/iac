import { StackProps } from "aws-cdk-lib";
import { CfnPublicRepository } from "aws-cdk-lib/aws-ecr";
import { User } from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { ECRPublicPusherPolicy } from "~/lib/constructs/iam/ECRPublicPusherPolicy";
import { kebabToPascalCase } from "~/lib/utils/string";

export interface ManagedECRPublicStackProps extends StackProps {
  prefix?: string;
  repositories: string[];
}

export class ManagedECRPublicStack extends Stack {
  constructor(
    scope: Construct,
    id: string,
    { prefix, repositories, ...props }: ManagedECRPublicStackProps,
  ) {
    super(scope, id, {
      ...props,
      env: {
        ...props.env,
        region: "us-east-1",
      },
    });

    const prefixed = repositories.map((repo) =>
      prefix ? `${prefix}/${repo}` : repo,
    );

    const repos = prefixed.map(
      (repo) =>
        new CfnPublicRepository(
          this,
          `${kebabToPascalCase(repo.replace(/\//g, "-"))}PublicRepository`,
          { repositoryName: repo },
        ),
    );

    const policy = new ECRPublicPusherPolicy(this, "Policy", {
      repositories: repos,
    });

    new User(this, "User", {
      userName: prefix ? `ecr-pusher-${prefix}` : "ecr-pusher",
      managedPolicies: [policy],
    });
  }
}
