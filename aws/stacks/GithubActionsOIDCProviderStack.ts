import { StackProps } from "aws-cdk-lib";
import { CfnPublicRepository } from "aws-cdk-lib/aws-ecr";
import { Effect, PolicyStatement } from "aws-cdk-lib/aws-iam";
import { StringParameter } from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { getContext } from "~/lib/cdk/context";
import { Stack } from "~/lib/cdk/Stack";
import { ECR, SSM } from "~/lib/constants";
import { ECRPublicPublisherPolicy } from "~/lib/constructs/iam/ECRPublicPublisherPolicy";
import { GithubActionsOIDCProvider } from "~/lib/constructs/iam/GithubActionsOIDCProvider";
import {
  GithubActionsRole,
  GithubActionsRoleProps,
} from "~/lib/constructs/iam/GithubActionsRole";
import { arn } from "~/lib/utils/arn";

export interface CreateGithubActionsECRPublisherRoleProps
  extends GithubActionsRoleProps {
  repositories: CfnPublicRepository[];
}

export class GithubActionsOIDCProviderStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);
    const ctx = getContext(this);

    const provider = new GithubActionsOIDCProvider(this, "OIDCProvider");

    this.output("OIDCProviderARN", provider.attrArn);

    new StringParameter(this, "OIDCProviderARNParameter", {
      parameterName: SSM.GithubActionsOIDCProviderARN,
      stringValue: provider.attrArn,
    });

    const iacDiffRole = new GithubActionsRole(this, "IACDiffRole", {
      providerArn: provider.attrArn,
      claims: {
        repositories: ["hans-m-song/iac", "hans-m-song/blog"],
        contexts: [{ pullRequest: true }, { branch: "*" }],
      },
    });

    iacDiffRole.addToPolicy(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["sts:AssumeRole"],
        resources: [ctx.bootstrapRoleARN("lookup-role")],
      }),
    );

    this.output("IACDiffRoleARN", iacDiffRole.roleArn);

    new StringParameter(this, "IACDiffRoleARNParameter", {
      parameterName: SSM.GithubActionsIACDiffRoleARN,
      stringValue: iacDiffRole.roleArn,
    });

    const iacDeployRole = new GithubActionsRole(this, "IACDeployRole", {
      providerArn: provider.attrArn,
      claims: {
        repositories: ["hans-m-song/iac", "hans-m-song/blog"],
        contexts: [{ environment: "aws" }],
        actors: ["hans-m-song"],
      },
    });

    iacDeployRole.addToPolicy(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["sts:AssumeRole"],
        resources: [
          ctx.bootstrapRoleARN("lookup-role"),
          ctx.bootstrapRoleARN("deploy-role"),
          ctx.bootstrapRoleARN("image-publishing-role"),
          ctx.bootstrapRoleARN("file-publishing-role"),
          ctx.bootstrapRoleARN("cfn-exec-role"),
        ],
      }),
    );

    this.output("IACDeployRoleARN", iacDeployRole.roleArn);

    new StringParameter(this, "IACDeployRoleARNParameter", {
      parameterName: SSM.GithubActionsIACDeployRoleARN,
      stringValue: iacDeployRole.roleArn,
    });

    const imagePublisherRole = new GithubActionsRole(this, "ECRPublisherRole", {
      claims: {
        repositories: [
          "axatol/*",
          "hans-m-song/huisheng",
          "hans-m-song/kube-stack",
        ],
        contexts: [{ branch: "master" }],
        actors: ["hans-m-song"],
      },
    });

    imagePublisherRole.addManagedPolicy(
      new ECRPublicPublisherPolicy(imagePublisherRole, "PublisherPolicy", {
        repositories: [
          arn().repository("ecr-public", ECR.GithubActionsRunner),
          arn().repository("ecr-public", ECR.HomeAssistantIntegrations),
          arn().repository("ecr-public", ECR.Huisheng),
          arn().repository("ecr-public", ECR.JAYD),
        ],
      }),
    );

    this.output("ImagePublisherRole", imagePublisherRole.roleArn);

    new StringParameter(this, "ECRPublisherRoleARNParameter", {
      parameterName: SSM.GithubActionsECRPublisherRoleARN,
      stringValue: imagePublisherRole.roleArn,
    });

    const songmatrixImagePublisherRole = new GithubActionsRole(
      this,
      "SongMatrixECRPublisherRole",
      {
        claims: {
          repositories: ["songmatrix/*"],
          contexts: [{ branch: "master" }],
        },
      },
    );

    songmatrixImagePublisherRole.addManagedPolicy(
      new ECRPublicPublisherPolicy(
        songmatrixImagePublisherRole,
        "PublisherPolicy",
        {
          repositories: [
            arn().repository("ecr-public", ECR.Songmatrix_DataService),
            arn().repository("ecr-public", ECR.Songmatrix_Gateway),
            arn().repository("ecr-public", ECR.Songmatrix_SyncService),
          ],
        },
      ),
    );

    this.output(
      "SongmatrixImagePublisherRole",
      songmatrixImagePublisherRole.roleArn,
    );

    new StringParameter(this, "SongmatrixImagePublisherRoleARNParameter", {
      parameterName: SSM.GithubActionsSongMatrixECRPublisherRoleARN,
      stringValue: songmatrixImagePublisherRole.roleArn,
    });
  }
}
