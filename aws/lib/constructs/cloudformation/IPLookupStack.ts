import * as apiv2 from "aws-cdk-lib/aws-apigatewayv2";
import * as api2i from "aws-cdk-lib/aws-apigatewayv2-integrations";
import * as acm from "aws-cdk-lib/aws-certificatemanager";
import * as lambda from "aws-cdk-lib/aws-lambda";
import * as nodejs from "aws-cdk-lib/aws-lambda-nodejs";
import * as r53 from "aws-cdk-lib/aws-route53";
import * as r53t from "aws-cdk-lib/aws-route53-targets";
import { Construct } from "constructs";

import { Stack, StackProps } from "~/lib/cdk/Stack";
import { hostedZones } from "~/lib/constants";

export interface IPLookupStackProps extends StackProps {
  domainName: string;
}

export class IPLookupStack extends Stack {
  constructor(
    scope: Construct,
    id: string,
    { domainName, ...props }: IPLookupStackProps,
  ) {
    super(scope, id, props);

    const handler = new nodejs.NodejsFunction(this, "Handler", {
      entry: "lib/handlers/ip-lookup.ts",
      handler: "handler",
      runtime: lambda.Runtime.NODEJS_18_X,
    });

    const certificate = new acm.Certificate(this, "Certificate", {
      domainName,
      validation: acm.CertificateValidation.fromDns(),
    });

    const domain = new apiv2.DomainName(this, "Domain", {
      domainName,
      certificate: certificate,
    });

    const api = new apiv2.HttpApi(this, "API", {
      defaultDomainMapping: { domainName: domain },
    });

    api.addRoutes({
      path: "/",
      methods: [apiv2.HttpMethod.GET],
      integration: new api2i.HttpLambdaIntegration("Integration", handler),
    });

    const zone = r53.HostedZone.fromHostedZoneAttributes(
      this,
      "Zone",
      hostedZones.axatol_xyz,
    );

    new r53.ARecord(this, "Record", {
      zone,
      recordName: domainName,
      target: r53.RecordTarget.fromAlias(
        new r53t.ApiGatewayv2DomainProperties(
          domain.regionalDomainName,
          domain.regionalHostedZoneId,
        ),
      ),
    });
  }
}
