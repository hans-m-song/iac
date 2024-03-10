import * as cdk from "aws-cdk-lib";
import * as ecr from "aws-cdk-lib/aws-ecr";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { Region, SSM } from "~/lib/constants";
import { ECRPublicPublisherPolicy } from "~/lib/constructs/iam/ECRPublicPublisherPolicy";
import { MultiRegionStringParameter } from "~/lib/constructs/ssm/MultiRegionStringParameter";
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

    const ecrRepos = repositories.map((repo) => {
      const id = kebabToPascalCase(repo.replace(/\//g, "-"));

      return new ecr.CfnPublicRepository(this, `${id}PublicRepository`, {
        repositoryName: repo,
      });
    });

    const managedPolicy = new ECRPublicPublisherPolicy(this, "ManagedPolicy", {
      repositories: ecrRepos,
    });

    new MultiRegionStringParameter(this, "ManagedPolicyParameter", {
      regions: Object.values(Region),
      parameterName: SSM.IAMECRImagePublisherManagedPolicyARN,
      stringValue: managedPolicy.managedPolicyArn,
    });
  }
}
