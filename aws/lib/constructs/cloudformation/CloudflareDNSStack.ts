import { Construct } from "constructs";
import { createHash } from "crypto";

import { Stack, StackProps } from "~/lib/cdk/Stack";
import {
  CloudflareRecord,
  CloudflareRecordProps,
} from "~/lib/constructs/route53/CloudflareRecord";
import { urlToPascalCase } from "~/lib/utils/string";

export interface CloudflareDNSStackProps extends StackProps {
  records: CloudflareRecordProps[];
}

export class CloudflareDNSStack extends Stack {
  constructor(
    scope: Construct,
    id: string,
    { records, ...props }: CloudflareDNSStackProps,
  ) {
    super(scope, id, props);

    records.forEach((record) => {
      const hash = createHash("MD5")
        .update(record.name)
        .update(record.type)
        .update(record.value)
        .digest("hex")
        .slice(0, 8);

      new CloudflareRecord(
        this,
        record.type + urlToPascalCase(record.name) + hash,
        record,
      );
    });
  }
}
