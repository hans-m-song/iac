import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";

export class HealthcheckStack extends Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
  }
}
