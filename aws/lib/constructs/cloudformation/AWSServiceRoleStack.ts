import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { CloudTrailLoggingRole } from "~/lib/constructs/iam/CloudTrailLoggingRole";

export class AWSServiceRoleStack extends Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const cloudTrailLoggingRole = new CloudTrailLoggingRole(
      this,
      "CloudTrailLoggingRole",
    );

    this.output("CloudTrailLoggingRoleARN", cloudTrailLoggingRole.roleArn);
  }
}
