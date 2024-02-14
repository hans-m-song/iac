import * as cdk from "aws-cdk-lib";
import * as iam from "aws-cdk-lib/aws-iam";
import * as logs from "aws-cdk-lib/aws-logs";
import * as cr from "aws-cdk-lib/custom-resources";
import { Construct } from "constructs";

import { SingletonConstruct } from "~/lib/cdk/SingletonConstruct";
import { SSM } from "~/lib/constants";
import { NodejsFunction } from "~/lib/constructs/lambda/NodejsFunction";
import { arn } from "~/lib/utils/arn";

export interface CloudflareRecordProps {
  site: string;
  name: string;
  type: string;
  value: string;
  ttl?: number;
  proxied?: boolean;
}

export class CloudflareRecord extends Construct {
  static RESOURCE_TYPE = "Custom::CloudflareRecord";
  static PROVIDER_ID = "CloudflareRecordProvider";
  static ON_EVENT_HANDLER_ID = "CloudflareRecordOnEventHandler";
  static IS_COMPLETE_HANDLER_ID = "CloudflareRecordIsCompleteHandler";

  constructor(scope: Construct, id: string, props: CloudflareRecordProps) {
    super(scope, id);

    const apiTokenParam = `${SSM.CloudflareSitePrefix}/${props.site}/dns_api_token`;
    const zoneIdParam = `${SSM.CloudflareSitePrefix}/${props.site}/zone_id`;

    const onEventFn = NodejsFunction.asSingleton(
      this,
      CloudflareRecord.ON_EVENT_HANDLER_ID,
      {
        entry: "cloudflare-record.ts",
        handler: "onEvent",
        timeout: cdk.Duration.seconds(5),
      },
    );

    onEventFn.addToRolePolicy(
      new iam.PolicyStatement({
        actions: ["ssm:GetParameter"],
        resources: [
          arn().ssm.parameter(apiTokenParam),
          arn().ssm.parameter(zoneIdParam),
        ],
      }),
    );

    const provider = new SingletonConstruct(cr.Provider).get(
      this,
      CloudflareRecord.PROVIDER_ID,
      {
        onEventHandler: onEventFn,
        logGroup: new logs.LogGroup(this, "LogGroup", {
          retention: logs.RetentionDays.ONE_MONTH,
          logGroupName: `/aws/custom/${CloudflareRecord.PROVIDER_ID}/${id}`,
        }),
      },
    );

    new cdk.CustomResource(this, "Resource", {
      resourceType: CloudflareRecord.RESOURCE_TYPE,
      serviceToken: provider.serviceToken,
      properties: {
        ApiTokenPath: apiTokenParam,
        ZoneIdPath: zoneIdParam,
        Name: props.name,
        Type: props.type,
        Value: props.value,
        Ttl: props.ttl ?? 300,
        Proxied: props.proxied ?? true,
      },
    });
  }
}
