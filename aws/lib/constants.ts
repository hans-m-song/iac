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

  ExecutionBoundaryPolicyARN = "infrastructure/iam/execution_boundary_policy_arn",
  UserBoundaryPolicyARN = "infrastructure/iam/user_boundary_policy_arn",

  NewRelicLicenseKey = "/infrastructure/new_relic/license_key",

  GithubActionsOIDCProviderARN = "/infrastructure/github/actions_oidc_provider_arn",
  GithubActionsIACDiffRoleARN = "/infrastructure/github/actions_iac_diff_role_arn",
  GithubActionsIACDeployRoleARN = "/infrastructure/github/actions_iac_deploy_role_arn",

  Auth0OIDCProviderARN = "/infrastructure/auth0/oidc_provider_arn",
}
