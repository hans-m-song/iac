import { StackProps } from "aws-cdk-lib";
import { CfnPublicRepository } from "aws-cdk-lib/aws-ecr";
import { Effect } from "aws-cdk-lib/aws-iam";
import { StringParameter } from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { getContext } from "~/lib/cdk/context";
import { Stack } from "~/lib/cdk/Stack";
import { ECR, Region, SSM } from "~/lib/constants";
import { ECRPublicPublisherPolicy } from "~/lib/constructs/iam/ECRPublicPublisherPolicy";
import { GithubActionsOIDCProvider } from "~/lib/constructs/iam/GithubActionsOIDCProvider";
import {
  GithubActionsRole,
  GithubActionsRoleProps,
  GithubActionsSubjectClaims,
} from "~/lib/constructs/iam/GithubActionsRole";
import { arn } from "~/lib/utils/arn";

export interface CreateGithubActionsECRPublisherRoleProps
  extends GithubActionsRoleProps {
  repositories: CfnPublicRepository[];
}

export class GithubActionsOIDCProviderStack extends Stack {
  provider: GithubActionsOIDCProvider;

  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);
    const ctx = getContext(this);

    this.provider = new GithubActionsOIDCProvider(this, "OIDCProvider");
    this.output("OIDCProviderARN", this.provider.attrArn);

    new StringParameter(this, "OIDCProviderARNParameter", {
      parameterName: SSM.GithubActionsOIDCProviderARN,
      stringValue: this.provider.attrArn,
    });

    const cdkDiffRole = this.role(
      "CDKDiffRole",
      [
        { repo: "hans-m-song/iac", context: { pr: true, ref: "*" } },
        { repo: "hans-m-song/blog", context: { ref: "*", env: "public" } },
        { repo: "axatol/where-gate", context: { ref: "master" } },
      ],
      SSM.GithubActionsCDKDiffRoleARN,
    );

    cdkDiffRole.addPolicies({
      effect: Effect.ALLOW,
      actions: ["sts:AssumeRole"],
      resources: [ctx.bootstrapRoleARN("lookup-role")],
    });

    const cdkDeployRole = this.role(
      "CDKDeployRole",
      [
        {
          repo: "hans-m-song/iac",
          context: { env: "aws" },
          actor: "hans-m-song",
        },
        {
          repo: "hans-m-song/blog",
          context: { env: "public" },
          actor: "hans-m-song",
        },
        {
          repo: "axatol/where-gate",
          context: { ref: "master" },
          actor: "hans-m-song",
        },
      ],
      SSM.GithubActionsCDKDeployRoleARN,
    );

    cdkDeployRole.addPolicies({
      effect: Effect.ALLOW,
      actions: ["sts:AssumeRole"],
      resources: [
        ctx.bootstrapRoleARN("lookup-role"),
        ctx.bootstrapRoleARN("deploy-role"),
        ctx.bootstrapRoleARN("image-publishing-role"),
        ctx.bootstrapRoleARN("file-publishing-role"),
        ctx.bootstrapRoleARN("cfn-exec-role"),
      ],
    });

    const ecrPublisherRole = this.role(
      "ECRPublisherRole",
      ["axatol/*", "hans-m-song/huisheng"].map((repo) => ({
        repo,
        context: { ref: "master" },
        actor: "hans-m-song",
      })),
      SSM.GithubActionsECRPublisherRoleARN,
    );

    ecrPublisherRole.addManagedPolicy(
      new ECRPublicPublisherPolicy(this, "ECRPublisherPolicy", {
        repositories: [
          arn().ecrp.repository(ECR.ActionsRunnerBrokerDispatcher),
          arn().ecrp.repository(ECR.GithubActionsRunner),
          arn().ecrp.repository(ECR.HomeAssistantIntegrations),
          arn().ecrp.repository(ECR.Huisheng),
          arn().ecrp.repository(ECR.JAYD),
        ],
      }),
    );

    const songmatrixECRPublisherRole = this.role(
      "SongMatrixECRPublisherRole",
      [{ repo: "songmatrix/*", context: { ref: "master" } }],
      SSM.GithubActionsSongMatrixECRPublisherRoleARN,
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

    const cloudFrontInvalidatorRole = this.role(
      "CloudFrontInvalidatorRole",
      [{ repo: "hans-m-song/blog", context: { env: "public", ref: "master" } }],
      SSM.GithubActionsCloudFrontInvalidatorRoleARN,
    );

    cloudFrontInvalidatorRole.addPolicies({
      effect: Effect.ALLOW,
      actions: ["cloudfront:CreateInvalidation", "cloudfront:GetInvalidation"],
      resources: [arn().cf.distribution("*")],
    });

    cloudFrontInvalidatorRole.addPolicies({
      effect: Effect.ALLOW,
      actions: ["ssm:GetParameter"],
      resources: [
        arn(Region.NVirginia).ssm.parameter("/infrastructure/cloudfront/*"),
      ],
    });

    const terraformLookupRole = this.role(
      "TerraformLookupRole",
      [{ repo: "hans-m-song/iac", context: { env: "github" } }],
      SSM.GithubActionsTerraformLookupRoleARN,
    );

    terraformLookupRole.addPolicies({
      effect: Effect.ALLOW,
      actions: ["ssm:GetParameter"],
      resources: [arn().ssm.parameter("/infrastructure/github/actions_*")],
    });
  }

  role(
    id: string,
    claims: GithubActionsSubjectClaims[],
    parameterName?: string,
  ) {
    const role = new GithubActionsRole(this, id, {
      providerArn: this.provider.attrArn,
      claims,
    });

    this.output(`${id}ARN`, role.roleArn);

    if (parameterName) {
      new StringParameter(this, `${id}ARNParameter`, {
        parameterName,
        stringValue: role.roleArn,
      });
    }

    return role;
  }
}
