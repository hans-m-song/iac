import * as cdk from "aws-cdk-lib";
import * as r53 from "aws-cdk-lib/aws-route53";
import * as r53t from "aws-cdk-lib/aws-route53-targets";
import { Construct } from "constructs";

import { Stack, StackProps } from "~/lib/cdk/Stack";
import { snakeToPascalCase, urlToPascalCase } from "~/lib/utils/string";

export interface RecordProps {
  a?: string[];
  aaaa?: string[];
  cname?: string;
  ttl?: number;
}

interface Records {
  a?: r53.ARecord[];
  aaaa?: r53.AaaaRecord[];
  cname?: r53.CnameRecord;
}

export interface CNamesStackProps extends StackProps {
  records: Record<string, RecordProps>;
  hostedZones: Record<string, r53.HostedZoneAttributes>;
}

export class DNSStack extends Stack {
  hostedZones: Record<string, r53.IHostedZone> = {};
  records: Record<string, Records> = {};

  constructor(
    scope: Construct,
    id: string,
    { records, hostedZones, ...props }: CNamesStackProps,
  ) {
    super(scope, id, props);

    this.hostedZones = Object.fromEntries(
      Object.entries(hostedZones).map(([name, attributes]) => [
        attributes.zoneName,
        r53.HostedZone.fromHostedZoneAttributes(
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
      const ttl = props.ttl ? cdk.Duration.minutes(props.ttl) : undefined;

      const zone = this.hostedZone(recordName);

      if (props.a?.length) {
        new r53.ARecord(zone, `${recordID}ARecord`, {
          zone,
          recordName: record,
          target: r53.RecordTarget.fromIpAddresses(...props.a),
          ttl,
        });
      }

      if (props.aaaa?.length) {
        new r53.AaaaRecord(zone, `${recordID}AAAARecord`, {
          zone,
          recordName: record,
          target: r53.RecordTarget.fromIpAddresses(...props.aaaa),
          ttl,
        });
      }

      if (props.cname) {
        const value = props.cname.endsWith(".")
          ? props.cname
          : `${props.cname}.`;

        new r53.CnameRecord(zone, `${recordID}CNameRecord`, {
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
