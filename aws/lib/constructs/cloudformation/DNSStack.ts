import * as cdk from "aws-cdk-lib";
import * as r53 from "aws-cdk-lib/aws-route53";
import { Construct } from "constructs";

import { Stack, StackProps } from "~/lib/cdk/Stack";
import { urlToPascalCase } from "~/lib/utils/string";

export interface RecordProps {
  name: string;
  hostedZone: r53.HostedZoneAttributes;
  ttl?: number;
  a?: string[];
  aaaa?: string[];
  cname?: string;
}

export interface RecordCollection {
  a?: r53.ARecord;
  aaaa?: r53.AaaaRecord;
  cname?: r53.CnameRecord;
}

export interface DNSStackProps extends StackProps {
  records: RecordProps[];
}

export class DNSStack extends Stack {
  hostedZones: Record<string, r53.IHostedZone> = {};
  records: Record<string, RecordCollection> = {};

  constructor(
    scope: Construct,
    id: string,
    { records, ...props }: DNSStackProps,
  ) {
    super(scope, id, props);

    for (const props of records) {
      const hostedZone = this.fromHostedZoneAttributes(props.hostedZone);
      this.addRecordSet(hostedZone, props);
    }
  }

  private fromHostedZoneAttributes(
    hostedZone: r53.HostedZoneAttributes,
  ): r53.IHostedZone {
    if (!this.hostedZones[hostedZone.zoneName]) {
      this.hostedZones[hostedZone.zoneName] =
        r53.HostedZone.fromHostedZoneAttributes(
          this,
          `${urlToPascalCase(hostedZone.zoneName)}HostedZone`,
          hostedZone,
        );
    }

    return this.hostedZones[hostedZone.zoneName];
  }

  addRecordSet(hostedZone: r53.IHostedZone, props: RecordProps) {
    const recordName = props.name.replace(/\.$/, "");
    const recordID = urlToPascalCase(recordName);
    const ttl = props.ttl ? cdk.Duration.minutes(props.ttl) : undefined;

    if (!this.records[recordName]) {
      this.records[recordName] = {};
    }

    if (props.a) {
      if (this.records[recordName].a) {
        throw new Error(`a record with name ${recordName} already exists`);
      }

      this.records[recordName].a = new r53.ARecord(
        hostedZone,
        `${recordID}ARecord`,
        {
          zone: hostedZone,
          recordName: props.name,
          target: r53.RecordTarget.fromIpAddresses(...props.a),
          ttl,
        },
      );
    }

    if (props.aaaa) {
      if (this.records[recordName].aaaa) {
        throw new Error(`aaaa record with name ${recordName} already exists`);
      }

      this.records[recordName].aaaa = new r53.AaaaRecord(
        hostedZone,
        `${recordID}AAAARecord`,
        {
          zone: hostedZone,
          recordName: props.name,
          target: r53.RecordTarget.fromIpAddresses(...props.aaaa),
          ttl,
        },
      );
    }

    if (props.cname) {
      if (this.records[recordName].cname) {
        throw new Error(`cname record with name ${recordName} already exists`);
      }

      this.records[recordName].cname = new r53.CnameRecord(
        hostedZone,
        `${recordID}CNameRecord`,
        {
          zone: hostedZone,
          recordName: props.name,
          domainName: props.cname,
          ttl,
        },
      );
    }
  }
}
