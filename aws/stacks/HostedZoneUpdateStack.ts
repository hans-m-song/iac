import { StackProps } from "aws-cdk-lib";
import { User } from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { HostedZoneUpdatePolicy } from "~/lib/constructs/iam/HostedZoneUpdatePolicy";

const hostedZones = [
  { zoneName: "hsong.me", hostedZoneId: "Z09233301OJXCBONJC133" },
  { zoneName: "axatol.xyz", hostedZoneId: "Z067173715955IHMKKU3W" },
];

export class HostedZoneUpdateStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
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
