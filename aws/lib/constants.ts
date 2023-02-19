export enum Region {
  // Sydney
  APSE2 = "ap-southeast-2",

  // N. Virginia
  USE1 = "us-east-1",
}

export enum URI {
  NewRelicLogsFirehose = "https://aws-api.newrelic.com/firehose/v1",
  GithubActionsToken = "https://token.actions.githubusercontent.com",
  Auth0Tenant = "https://axatol.au.auth0.com",
}

export enum Domain {
  AWSSTSServiceEndpoint = "sts.amazonaws.com",
  GithubActionsToken = "token.actions.githubusercontent.com",
  GithubActionsOIDCAudience = "sts.amazonaws.com",
  Auth0Tenant = "axatol.au.auth0.com",
}

export enum SSM {
  CDKBootstrapVersion = "/cdk-bootstrap/toolkit/version",

  ExecutionBoundaryPolicyARN = "/infrastructure/iam/execution_boundary_policy_arn",
  UserBoundaryPolicyARN = "/infrastructure/iam/user_boundary_policy_arn",

  NewRelicLicenseKey = "/infrastructure/new_relic/license_key",

  GithubActionsOIDCProviderARN = "/infrastructure/github/actions_oidc_provider_arn",
  GithubActionsLookupRoleARN = "/infrastructure/github/actions_lookup_role_arn",
  GithubActionsIACDiffRoleARN = "/infrastructure/github/actions_iac_diff_role_arn",
  GithubActionsIACDeployRoleARN = "/infrastructure/github/actions_iac_deploy_role_arn",
  GithubActionsECRPublisherRoleARN = "/infrastructure/github/actions_ecr_image_publisher_role_arn",
  GithubActionsSongMatrixECRPublisherRoleARN = "/infrastructure/github/actions_songmatrix_ecr_image_publisher_role_arn",

  Auth0OIDCProviderARN = "/infrastructure/auth0/oidc_provider_arn",
}

export enum ECR {
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
