import { aws_iam } from "aws-cdk-lib";
import { ManagedPolicyProps } from "aws-cdk-lib/aws-iam";
import { HostedZone, HostedZoneAttributes } from "aws-cdk-lib/aws-route53";
import { Construct } from "constructs";

import { urlToPascalCase } from "~/lib/utils/string";

export interface HostedZoneUpdatePolicyProps extends ManagedPolicyProps {
  hostedZones: HostedZoneAttributes[];
}

export class HostedZoneUpdatePolicy extends aws_iam.ManagedPolicy {
  constructor(
    scope: Construct,
    id: string,
    { hostedZones, ...props }: HostedZoneUpdatePolicyProps,
  ) {
    super(scope, id, props);

    this.addStatements(
      new aws_iam.PolicyStatement({
        effect: aws_iam.Effect.ALLOW,
        actions: ["route53:ListHostedZones", "route53:GetChange"],
        resources: ["*"],
      }),
    );

    hostedZones.forEach(({ hostedZoneId, zoneName }) => {
      const hz = HostedZone.fromHostedZoneAttributes(this, zoneName, {
        hostedZoneId,
        zoneName,
      });

      this.addStatements(
        new aws_iam.PolicyStatement({
          sid: `UpdateRecordsFor${urlToPascalCase(zoneName)}`,
          effect: aws_iam.Effect.ALLOW,
          actions: [
            "route53:ChangeResourceRecordSets",
            "route53:ListResourceRecordSets",
          ],
          resources: [hz.hostedZoneArn],
        }),
      );
    });
  }
}
