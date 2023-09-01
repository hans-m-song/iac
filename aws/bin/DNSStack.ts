import { Duration, StackProps } from "aws-cdk-lib";
import {
  ARecord,
  CnameRecord,
  HostedZone,
  HostedZoneAttributes,
  IHostedZone,
  RecordTarget,
} from "aws-cdk-lib/aws-route53";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { snakeToPascalCase, urlToPascalCase } from "~/lib/utils/string";

export type RecordProps =
  | { type: "a"; a: string[]; ttl?: number }
  | { type: "cname"; cname: string; ttl?: number };

export interface CNamesStackProps extends StackProps {
  records: Record<string, RecordProps>;
  hostedZones: Record<string, HostedZoneAttributes>;
}

export class DNSStack extends Stack {
  hostedZones: Record<string, IHostedZone> = {};

  constructor(
    scope: Construct,
    id: string,
    { records, hostedZones, ...props }: CNamesStackProps,
  ) {
    super(scope, id, props);

    this.hostedZones = Object.fromEntries(
      Object.entries(hostedZones).map(([name, attributes]) => [
        attributes.zoneName,
        HostedZone.fromHostedZoneAttributes(
          this,
          `${snakeToPascalCase(name)}HostedZone`,
          attributes,
        ),
      ]),
    );

    Object.entries(records).forEach(([record, props]) => {
      if (!record.endsWith(".")) {
        throw new Error("must specify a FQDN, e.g. foo.example.com.");
      }

      const recordName = record.replace(/\.$/, "");
      const recordID = urlToPascalCase(recordName);
      const ttl = props.ttl ? Duration.minutes(props.ttl) : undefined;

      const zone = this.hostedZone(recordName);

      if (props.type === "a" && props.a.length > 0) {
        const invalid = props.a.filter((a) => {
          if (!/^\d+\.\d+\.\d+\.\d+$/.test(a)) {
            throw new Error("a record was not a valid ip");
          }
        });

        if (invalid.length > 0) {
          throw new Error(`invalid ips: [${invalid.join(", ")}]`);
        }

        new ARecord(zone, `${recordID}ARecord`, {
          zone,
          recordName: record,
          target: RecordTarget.fromIpAddresses(...props.a),
          ttl,
        });
      }

      if (props.type === "cname") {
        const value = props.cname.endsWith(".")
          ? props.cname
          : `${props.cname}.`;

        new CnameRecord(zone, `${recordID}CNameRecord`, {
          zone,
          recordName: record,
          domainName: value,
          ttl,
        });
      }
    });
  }

  hostedZone(domain: string) {
    const zone = Object.values(this.hostedZones).find((zone) =>
      domain.endsWith(zone.zoneName),
    );

    if (!zone) {
      throw new Error(`no hosted zone configured to serve domain "${domain}"`);
    }

    return zone;
  }
}
