import { Arn, aws_iam } from "aws-cdk-lib";
import { Construct } from "constructs";

export interface HostedZone {
  name: string;
  id: string;
}

export class HostedZoneUpdatePolicy extends aws_iam.ManagedPolicy {
  constructor(scope: Construct, hostedZones: HostedZone[]) {
    super(scope, `${scope.node.id}-Policy`, {
      statements: [
        new aws_iam.PolicyStatement({
          sid: "ReadHostedZones",
          effect: aws_iam.Effect.ALLOW,
          actions: ["route53:ListHostedZones", "route53:GetChange"],
          resources: ["*"],
        }),
        ...hostedZones.map(
          ({ name, id }) =>
            new aws_iam.PolicyStatement({
              sid: `UpdateRecords${name}`,
              effect: aws_iam.Effect.ALLOW,
              actions: ["route53:ChangeResourceRecordSets"],
              resources: [
                Arn.format({
                  partition: "aws",
                  service: "route53",
                  region: "",
                  account: "",
                  resource: `hostedzone/${id}`,
                }),
              ],
            }),
        ),
      ],
    });
  }
}
