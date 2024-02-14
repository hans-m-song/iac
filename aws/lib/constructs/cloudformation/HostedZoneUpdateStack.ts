import * as cdk from "aws-cdk-lib";
import { User } from "aws-cdk-lib/aws-iam";
import { HostedZoneAttributes } from "aws-cdk-lib/aws-route53";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { HostedZoneUpdatePolicy } from "~/lib/constructs/iam/HostedZoneUpdatePolicy";

export interface HostedZoneUpdateStackProps extends cdk.StackProps {
  hostedZones: HostedZoneAttributes[];
}

export class HostedZoneUpdateStack extends Stack {
  constructor(
    scope: Construct,
    id: string,
    { hostedZones, ...props }: HostedZoneUpdateStackProps,
  ) {
    super(scope, id, props);

    const policy = new HostedZoneUpdatePolicy(this, "Policy", {
      hostedZones,
    });

    new User(this, "User", {
      userName: "hosted-zone-updater",
      managedPolicies: [policy],
    });
  }
}
