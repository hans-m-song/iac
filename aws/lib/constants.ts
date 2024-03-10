export enum Region {
  Sydney = "ap-southeast-2",
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
  CDKBootstrapVersion = "/cdk-bootstrap/toolkit/version",
  CertificateParameterPrefix = "/infrastructure/acm",
  CloudflareSitePrefix = "/infrastructure/cloudflare/site",
  GithubActionsCDKDeployRoleARN = "/infrastructure/github_actions/cdk_deploy_role_arn",
  GithubActionsCDKDiffRoleARN = "/infrastructure/github_actions/cdk_diff_role_arn",
  GithubActionsCloudFrontInvalidatorRoleARN = "/infrastructure/github_actions/cloudfront_invalidator_role_arn",
  GithubActionsECRPublisherRoleARN = "/infrastructure/github_actions/ecr_image_publisher_role_arn",
  GithubActionsLookupRoleARN = "/infrastructure/github_actions/lookup_role_arn",
  GithubActionsOIDCProviderARN = "/infrastructure/github_actions/oidc_provider_arn",
  GithubActionsTerraformRoleARN = "/infrastructure/github_actions/terraform_role_arn",
  IAMECRImagePublisherManagedPolicyARN = "/infrastructure/iam/ecr_image_publisher_managed_policy_arn",
  IAMExecutionBoundaryPolicyARN = "/infrastructure/iam/execution_boundary_policy_arn",
  IAMLambdaBoundaryPolicyARN = "/infrastructure/iam/lambda_boundary_policy_arn",
  IAMTerraformBackendPolicyARN = "/infrastructure/iam/terraform_state_policy_arn",
  IAMUserBoundaryPolicyARN = "/infrastructure/iam/user_boundary_policy_arn",
  NewRelicAccountID = "/infrastructure/new_relic/account_id",
  TerraformLockTableName = "/infrastructure/terraform/lock_table_name",
  TerraformStateBucketName = "/infrastructure/terraform/state_bucket_name",
}

export enum ECR {
  ActionsJobDispatcher = "actions-job-dispatcher",
  ExternalDNSCloudflareTunnelWebhook = "external-dns-cloudflare-tunnel-webhook",
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
  cloud_axatol_xyz: {
    zoneName: "cloud.axatol.xyz",
    hostedZoneId: "Z06906322LG6UMVSAT4VH",
  },
};
