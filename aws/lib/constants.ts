export enum Region {
  // Sydney
  APSE2 = "ap-southeast-2",

  // N. Virginia
  USE1 = "us-east-1",
}

export enum Domain {
  NewRelicLogsFirehose = "aws-api.newrelic.com/firehose/v1",
  GithubActionsToken = "token.actions.githubusercontent.com",
  GithubActionsOIDCAudience = "sts.amazonaws.com",
}

export enum SSM {
  CDKBootstrapVersion = "/cdk-bootstrap/toolkit/version",
  NewRelicLicenseKey = "/infrastructure/new_relic/license_key",
  GithubActionsOIDCProviderARN = "/infrastructure/github/actions_oidc_provider_arn",
}
