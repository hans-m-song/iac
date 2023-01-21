import { StackProps } from "aws-cdk-lib";
import { CfnPublicRepository } from "aws-cdk-lib/aws-ecr";
import { User } from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { ECRPublicPusherPolicy } from "~/lib/constructs/iam/ECRPublicPusherPolicy";
import { kebabToPascalCase } from "~/lib/utils/string";

const repositories = [
  // { name: "github-actions-runner" },
  // { name: "home-assistant-integrations" },
  { name: "huisheng" },
];

export class ManagedECRPublicStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const publicRepos = repositories.map(
      (repo) =>
        new CfnPublicRepository(
          this,
          `${kebabToPascalCase(repo.name)}PublicRepository`,
          { repositoryName: repo.name },
        ),
    );

    const policy = new ECRPublicPusherPolicy(this, "Policy", {
      repositories: publicRepos,
    });

    new User(this, "User", {
      userName: "ecr-pusher",
      managedPolicies: [policy],
    });
  }
}
