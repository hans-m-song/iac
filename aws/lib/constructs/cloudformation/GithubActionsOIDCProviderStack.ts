import * as cdk from "aws-cdk-lib";
import * as ddb from "aws-cdk-lib/aws-dynamodb";
import * as ecr from "aws-cdk-lib/aws-ecr";
import * as iam from "aws-cdk-lib/aws-iam";
import * as s3 from "aws-cdk-lib/aws-s3";
import * as ssm from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { getContext } from "~/lib/cdk/context";
import { Stack } from "~/lib/cdk/Stack";
import { Region, SSM } from "~/lib/constants";
import { GithubActionsOIDCProvider } from "~/lib/constructs/iam/GithubActionsOIDCProvider";
import {
  GithubActionsRole,
  GithubActionsRoleProps,
  GithubActionsSubjectClaims,
} from "~/lib/constructs/iam/GithubActionsRole";
import { arn } from "~/lib/utils/arn";

export interface CreateGithubActionsECRPublisherRoleProps
  extends GithubActionsRoleProps {
  repositories: ecr.CfnPublicRepository[];
}

export class GithubActionsOIDCProviderStack extends Stack {
  provider: GithubActionsOIDCProvider;

  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    const ctx = getContext(this);

    this.provider = new GithubActionsOIDCProvider(this, "OIDCProvider");
    this.output("OIDCProviderARN", this.provider.attrArn);

    new ssm.StringParameter(this, "OIDCProviderARNParameter", {
      parameterName: SSM.GithubActionsOIDCProviderARN,
      stringValue: this.provider.attrArn,
    });

    const cdkDiffRole = this.role(
      "CDKDiffRole",
      [
        { repo: "hans-m-song/iac", context: { pr: true, ref: "*" } },
        { repo: "hans-m-song/blog", context: { ref: "*", env: "public" } },
      ],
      SSM.GithubActionsCDKDiffRoleARN,
    );

    cdkDiffRole.addPolicies({
      effect: iam.Effect.ALLOW,
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
      ],
      SSM.GithubActionsCDKDeployRoleARN,
    );

    cdkDeployRole.addPolicies({
      effect: iam.Effect.ALLOW,
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
      [
        {
          repo: "axatol/*",
          context: { ref: "master" },
          actor: "hans-m-song",
        },
        {
          repo: "hans-m-song/huisheng",
          context: { ref: "master" },
          actor: "hans-m-song",
        },
        {
          repo: "hans-m-song/iac",
          context: { ref: "master" },
          actor: "hans-m-song",
        },
      ],
      SSM.GithubActionsECRPublisherRoleARN,
    );

    ecrPublisherRole.addManagedPolicy(
      iam.ManagedPolicy.fromManagedPolicyArn(
        this,
        "ECRImagePublisherManagedPolicy",
        ssm.StringParameter.valueForStringParameter(
          this,
          SSM.IAMECRImagePublisherManagedPolicyARN,
        ),
      ),
    );

    const cloudFrontInvalidatorRole = this.role(
      "CloudFrontInvalidatorRole",
      [{ repo: "hans-m-song/blog", context: { env: "public", ref: "master" } }],
      SSM.GithubActionsCloudFrontInvalidatorRoleARN,
    );

    cloudFrontInvalidatorRole.addPolicies(
      {
        effect: iam.Effect.ALLOW,
        actions: [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetInvalidation",
        ],
        resources: [arn().cf.distribution("*")],
      },
      {
        effect: iam.Effect.ALLOW,
        actions: ["ssm:GetParameter"],
        resources: [
          arn(Region.NVirginia).ssm.parameter("/infrastructure/cloudfront/*"),
        ],
      },
    );

    const terraformLockTable = ddb.Table.fromTableName(
      this,
      "LockTable",
      ssm.StringParameter.valueForStringParameter(
        this,
        SSM.TerraformLockTableName,
      ),
    );

    const terraformStateBucket = s3.Bucket.fromBucketName(
      this,
      "StateBucket",
      ssm.StringParameter.valueForStringParameter(
        this,
        SSM.TerraformStateBucketName,
      ),
    );

    const terraformRole = this.role(
      "TerraformRole",
      [{ repo: "hans-m-song/iac", context: { ref: "master" } }],
      SSM.GithubActionsTerraformRoleARN,
    );

    terraformLockTable.grantReadWriteData(terraformRole);
    terraformStateBucket.grantReadWrite(terraformRole);
    terraformRole.addPolicies({
      effect: iam.Effect.ALLOW,
      actions: ["ssm:GetParameter"],
      resources: [arn(Region.Sydney).ssm.parameter("/infrastructure/*")],
    });
  }

  role(
    id: string,
    claims: GithubActionsSubjectClaims[],
    opts?: { parameterName?: string; roleName?: string },
  ) {
    const { parameterName, roleName } = opts ?? {};
    const role = new GithubActionsRole(this, id, { roleName, claims });

    this.output(`${id}ARN`, role.roleArn);

    if (parameterName) {
      new ssm.StringParameter(this, `${id}ARNParameter`, {
        parameterName,
        stringValue: role.roleArn,
      });
    }

    return role;
  }
}
