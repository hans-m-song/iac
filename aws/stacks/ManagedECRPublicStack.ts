import { StackProps } from "aws-cdk-lib";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { PublicRepository } from "~/lib/constructs/ecr/PublicRepository";
import { ECRPublicPublisherPolicy } from "~/lib/constructs/iam/ECRPublicPublisherPolicy";
import {
  GithubActionsRole,
  GithubActionsRoleProps,
} from "~/lib/constructs/iam/GithubActionsRole";
import { kebabToPascalCase, pascalToWords } from "~/lib/utils/string";

export interface CreateGithubActionsPublisherRoleProps
  extends Omit<GithubActionsRoleProps, "claims"> {
  claims: GithubActionsRoleProps["claims"];
}

export interface ManagedECRPublicStackProps extends StackProps {
  repositories: string[];
}

export class ManagedECRPublicStack extends Stack {
  repositories: PublicRepository[];

  constructor(
    scope: Construct,
    id: string,
    { repositories, ...props }: ManagedECRPublicStackProps,
  ) {
    super(scope, id, {
      ...props,
      env: {
        ...props.env,
        region: "us-east-1",
      },
    });

    this.repositories = repositories.map((repo) => {
      const id = kebabToPascalCase(repo.replace(/\//g, "-"));

      return new PublicRepository(this, `${id}PublicRepository`, {
        repositoryName: repo,
      });
    });
  }

  createGithubActionsPublisherRole(id: string, props: GithubActionsRoleProps) {
    const role = new GithubActionsRole(this, id, {
      roleName: `${pascalToWords(this.node.id).join("-")}-image-publisher`,
      ...props,
    });

    const policy = new ECRPublicPublisherPolicy(role, "PublisherPolicy", {
      repositories: this.repositories,
    });

    role.addManagedPolicy(policy);

    return role;
  }
}
