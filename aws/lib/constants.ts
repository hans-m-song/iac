export enum Region {
  Sydney = "ap-southeast-2",
  Singapore = "ap-southeast-1",
  NVirginia = "us-east-1",
}

export enum URI {
  Auth0Tenant = "https://axatol.au.auth0.com",
  GithubActionsToken = "https://token.actions.githubusercontent.com",
  Terraform = "https://app.terraform.io",
  NewRelicLogsFirehose = "https://aws-api.newrelic.com/firehose/v1",
}

export enum Domain {
  Auth0Tenant = "axatol.au.auth0.com",
  AWS = "aws.amazon.com",
  Terraform = "app.terraform.io",
  TerraformAudience = "aws.workload.identity",
  AWSSecurityTokenService = "sts.amazonaws.com",
  GithubActionsToken = "token.actions.githubusercontent.com",
}

export enum SSM {
  Auth0OIDCProviderARN = "/infrastructure/auth0/oidc_provider_arn",
  CertificateParameterPrefix = "/infrastructure/acm",
  CDKBootstrapVersion = "/cdk-bootstrap/toolkit/version",
  GithubActionsCloudFrontInvalidatorRoleARN = "/infrastructure/github/actions_cloudfront_invalidator_role_arn",
  GithubActionsOIDCProviderARN = "/infrastructure/github/actions_oidc_provider_arn",
  GithubActionsLookupRoleARN = "/infrastructure/github/actions_lookup_role_arn",
  GithubActionsCDKDiffRoleARN = "/infrastructure/github/actions_cdk_diff_role_arn",
  GithubActionsCDKDeployRoleARN = "/infrastructure/github/actions_cdk_deploy_role_arn",
  GithubActionsECRPublisherRoleARN = "/infrastructure/github/actions_ecr_image_publisher_role_arn",
  GithubActionsSongMatrixECRPublisherRoleARN = "/infrastructure/github/actions_songmatrix_ecr_image_publisher_role_arn",
  GithubActionsTerraformRoleARN = "/infrastructure/github/actions_terraform_role_arn",
  IAMECRImagePublisherManagedPolicyARN = "/infrastructure/iam/ecr_image_publisher_managed_policy_arn",
  IAMExecutionBoundaryPolicyARN = "/infrastructure/iam/execution_boundary_policy_arn",
  IAMLambdaBoundaryPolicyARN = "/infrastructure/iam/lambda_boundary_policy_arn",
  IAMUserBoundaryPolicyARN = "/infrastructure/iam/user_boundary_policy_arn",
  NewRelicLicenseKey = "/infrastructure/new_relic/license_key",
  TerraformLockTableName = "/infrastructure/terraform/lock_table_name",
  TerraformStateBucketName = "/infrastructure/terraform/state_bucket_name",
}

export enum ECR {
  ActionsJobDispatcher = "actions-job-dispatcher",
  GithubActionsRunner = "github-actions-runner",
  HomeAssistantIntegrations = "home-assistant-integrations",
  Huisheng = "huisheng",
  JAYD = "jayd",
  OctopusDeployTentacle = "octopus-deploy-tentacle",
}

export const hostedZones = {
  hsong_me: {
    zoneName: "hsong.me",
    hostedZoneId: "Z09233301OJXCBONJC133",
  },
  axatol_xyz: {
    zoneName: "axatol.xyz",
    hostedZoneId: "Z067173715955IHMKKU3W",
  },
};
