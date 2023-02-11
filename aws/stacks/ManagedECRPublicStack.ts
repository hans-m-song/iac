import { StackProps } from "aws-cdk-lib";
import { CfnPublicRepository } from "aws-cdk-lib/aws-ecr";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { kebabToPascalCase } from "~/lib/utils/string";

export interface ManagedECRPublicStackProps extends StackProps {
  repositories: string[];
}

export class ManagedECRPublicStack extends Stack {
  repositories: CfnPublicRepository[];

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

      return new CfnPublicRepository(this, `${id}PublicRepository`, {
        repositoryName: repo,
      });
    });
  }
}
