import * as cdk from "aws-cdk-lib";
import * as ecr from "aws-cdk-lib/aws-ecr";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";

export interface ECRPrivateStackProps extends cdk.StackProps {
  repositories: string[];
}

export class ECRPrivateStack extends Stack {
  constructor(
    scope: Construct,
    id: string,
    { repositories, ...props }: ECRPrivateStackProps,
  ) {
    super(scope, id, props);

    repositories.map(
      (repo) =>
        new ecr.Repository(this, `${repo}Repository`, {
          repositoryName: repo,
          lifecycleRules: [
            {
              tagStatus: ecr.TagStatus.UNTAGGED,
              maxImageCount: 2,
            },
          ],
        }),
    );
  }
}
