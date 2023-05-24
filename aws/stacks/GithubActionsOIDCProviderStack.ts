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

    const cdkDiffRole = new GithubActionsRole(this, "CDKDiffRole", {
      providerArn: provider.attrArn,
      claims: {
        repositories: ["hans-m-song/iac", "hans-m-song/blog"],
        contexts: [{ pullRequest: true }, { branch: "*" }],
      },
    });

    cdkDiffRole.addPolicies(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["sts:AssumeRole"],
        resources: [ctx.bootstrapRoleARN("lookup-role")],
      }),
    );

    this.output("CDKDiffRoleARN", cdkDiffRole.roleArn);

    new StringParameter(this, "IACDiffRoleARNParameter", {
      parameterName: SSM.GithubActionsCDKDiffRoleARN,
      stringValue: cdkDiffRole.roleArn,
    });

    const cdkDeployRole = new GithubActionsRole(this, "CDKDeployRole", {
      providerArn: provider.attrArn,
      claims: {
        repositories: ["hans-m-song/iac", "hans-m-song/blog"],
        contexts: [{ environment: "aws" }],
        actors: ["hans-m-song"],
      },
    });

    cdkDeployRole.addPolicies(
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

    this.output("CDKDeployRoleARN", cdkDeployRole.roleArn);

    new StringParameter(this, "CDKDeployRoleARNParameter", {
      parameterName: SSM.GithubActionsCDKDeployRoleARN,
      stringValue: cdkDeployRole.roleArn,
    });

    const ecrPublisherRole = new GithubActionsRole(this, "ECRPublisherRole", {
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

    ecrPublisherRole.addManagedPolicy(
      new ECRPublicPublisherPolicy(ecrPublisherRole, "ECRPublisherPolicy", {
        repositories: [
          arn().ecrp.repository(ECR.ActionsRunnerBrokerDispatcher),
          arn().ecrp.repository(ECR.GithubActionsRunner),
          arn().ecrp.repository(ECR.HomeAssistantIntegrations),
          arn().ecrp.repository(ECR.Huisheng),
          arn().ecrp.repository(ECR.JAYD),
        ],
      }),
    );

    this.output("ECRPublisherRoleARN", ecrPublisherRole.roleArn);

    new StringParameter(this, "ECRPublisherRoleARNParameter", {
      parameterName: SSM.GithubActionsECRPublisherRoleARN,
      stringValue: ecrPublisherRole.roleArn,
    });

    const songmatrixECRPublisherRole = new GithubActionsRole(
      this,
      "SongMatrixECRPublisherRole",
      {
        claims: {
          repositories: ["songmatrix/*"],
          contexts: [{ branch: "master" }],
        },
      },
    );

    songmatrixECRPublisherRole.addManagedPolicy(
      new ECRPublicPublisherPolicy(
        songmatrixECRPublisherRole,
        "SongMatrixECRPublisherPolicy",
        {
          repositories: [
            arn().ecrp.repository(ECR.Songmatrix_DataService),
            arn().ecrp.repository(ECR.Songmatrix_Gateway),
            arn().ecrp.repository(ECR.Songmatrix_SyncService),
          ],
        },
      ),
    );

    this.output(
      "SongMatrixECRPublisherRoleARN",
      songmatrixECRPublisherRole.roleArn,
    );

    new StringParameter(this, "SongMatrixECRPublisherRoleParameter", {
      parameterName: SSM.GithubActionsSongMatrixECRPublisherRoleARN,
      stringValue: songmatrixECRPublisherRole.roleArn,
    });

    const cloudFrontInvalidatorRole = new GithubActionsRole(
      this,
      "CloudFrontInvalidatorRole",
      {
        providerArn: provider.attrArn,
        claims: {
          repositories: ["hans-m-song/blog"],
          contexts: [{ pullRequest: true }, { branch: "*" }],
        },
      },
    );

    cloudFrontInvalidatorRole.addPolicies(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetInvalidation",
          "cloudfront:ListInvalidations",
        ],
        resources: [arn().cf.distribution("*")],
      }),
    );

    this.output(
      "CloudFrontInvalidatorRoleARN",
      cloudFrontInvalidatorRole.roleArn,
    );

    new StringParameter(this, "CloudFrontInvalidatorRoleARNParameter", {
      parameterName: SSM.GithubActionsCloudFrontInvalidatorRoleARN,
      stringValue: cloudFrontInvalidatorRole.roleArn,
    });
  }
}
