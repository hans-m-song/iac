export enum Region {
  // Sydney
  APSE2 = "ap-southeast-2",

  // N. Virginia
  USE1 = "us-east-1",
}

export enum URI {
  Auth0Tenant = "https://axatol.au.auth0.com",
  GithubActionsToken = "https://token.actions.githubusercontent.com",
  NewRelicLogsFirehose = "https://aws-api.newrelic.com/firehose/v1",
}

export enum Domain {
  Auth0Tenant = "axatol.au.auth0.com",
  AWS = "aws.amazon.com",
  AWSSecurityTokenService = "sts.amazonaws.com",
  GithubActionsToken = "token.actions.githubusercontent.com",
}

export enum SSM {
  Auth0OIDCProviderARN = "/infrastructure/auth0/oidc_provider_arn",
  CertificateParameterPrefix = "/infrastructure/acm",
  CDKBootstrapVersion = "/cdk-bootstrap/toolkit/version",
  ExecutionBoundaryPolicyARN = "/infrastructure/iam/execution_boundary_policy_arn",
  GithubActionsCloudFrontInvalidatorRoleARN = "/infrastructure/github/actions_cloudfront_invalidator_role_arn",
  GithubActionsOIDCProviderARN = "/infrastructure/github/actions_oidc_provider_arn",
  GithubActionsLookupRoleARN = "/infrastructure/github/actions_lookup_role_arn",
  GithubActionsCDKDiffRoleARN = "/infrastructure/github/actions_cdk_diff_role_arn",
  GithubActionsCDKDeployRoleARN = "/infrastructure/github/actions_cdk_deploy_role_arn",
  GithubActionsECRPublisherRoleARN = "/infrastructure/github/actions_ecr_image_publisher_role_arn",
  GithubActionsSongMatrixECRPublisherRoleARN = "/infrastructure/github/actions_songmatrix_ecr_image_publisher_role_arn",
  GithubActionsTerraformLookupRoleARN = "/infrastructure/github/actions_terraform_lookup_role_arn",
  UserBoundaryPolicyARN = "/infrastructure/iam/user_boundary_policy_arn",
  NewRelicLicenseKey = "/infrastructure/new_relic/license_key",
}

export enum ECR {
  ActionsRunnerBrokerDispatcher = "actions-runner-broker-dispatcher",
  GithubActionsRunner = "github-actions-runner",
  HomeAssistantIntegrations = "home-assistant-integrations",
  Huisheng = "huisheng",
  JAYD = "jayd",
  Songmatrix_DataService = "songmatrix/data-service",
  Songmatrix_Gateway = "songmatrix/gateway",
  Songmatrix_SyncService = "songmatrix/sync-service",
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
