export enum Region {
  // Sydney
  APSE2 = "ap-southeast-2",

  // N. Virginia
  USE1 = "us-east-1",
}

export enum URI {
  NewRelicLogsFirehose = "https://aws-api.newrelic.com/firehose/v1",
}

export enum SSM {
  CDKBootstrapVersion = "/cdk-bootstrap/toolkit/version",
  NewRelicLicenseKey = "/infrastructure/new_relic/license_key",
}
