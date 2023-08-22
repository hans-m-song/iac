import { StackProps } from "aws-cdk-lib";
import { CfnPublicRepository } from "aws-cdk-lib/aws-ecr";
import { IManagedPolicy } from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { Region, SSM } from "~/lib/constants";
import { ECRPublicPublisherPolicy } from "~/lib/constructs/iam/ECRPublicPublisherPolicy";
import { MultiRegionStringParameter } from "~/lib/constructs/ssm/MultiRegionStringParameter";
import { kebabToPascalCase } from "~/lib/utils/string";

export interface ManagedECRPublicStackProps extends StackProps {
  repositories: string[];
}

export class ManagedECRPublicStack extends Stack {
  repositories: CfnPublicRepository[];
  managedPolicy: IManagedPolicy;

  constructor(
    scope: Construct,
    id: string,
    { repositories, ...props }: ManagedECRPublicStackProps,
  ) {
    super(scope, id, props);

    this.repositories = repositories.map((repo) => {
      const id = kebabToPascalCase(repo.replace(/\//g, "-"));

      return new CfnPublicRepository(this, `${id}PublicRepository`, {
        repositoryName: repo,
      });
    });

    this.managedPolicy = new ECRPublicPublisherPolicy(this, "ManagedPolicy", {
      repositories: this.repositories,
    });

    new MultiRegionStringParameter(this, "ManagedPolicyParameter", {
      regions: [Region.NVirginia, Region.Sydney],
      parameterName: SSM.IAMECRImagePublisherManagedPolicyARN,
      stringValue: this.managedPolicy.managedPolicyArn,
    });
  }
}
