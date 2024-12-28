import * as cdk from "aws-cdk-lib";
import * as ecr from "aws-cdk-lib/aws-ecr";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { kebabToPascalCase } from "~/lib/utils/string";

export interface ECRPublicStackProps extends cdk.StackProps {
  repositories: string[];
}

export class ECRPublicStack extends Stack {
  constructor(
    scope: Construct,
    id: string,
    { repositories, ...props }: ECRPublicStackProps,
  ) {
    super(scope, id, props);

    repositories.map((repo) => {
      const id = kebabToPascalCase(repo.replace(/\//g, "-"));

      return new ecr.CfnPublicRepository(this, `${id}PublicRepository`, {
        repositoryName: repo,
      });
    });
  }
}
