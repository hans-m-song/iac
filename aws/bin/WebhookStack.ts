import {
  DomainName,
  HttpApi,
  HttpMethod,
} from "@aws-cdk/aws-apigatewayv2-alpha";
import { StackProps, aws_certificatemanager, aws_route53 } from "aws-cdk-lib";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { hostedZones } from "~/lib/constants";
import { NotifyDiscordHandler } from "~/lib/constructs/lambda/NotifyDiscordHandler";

export class WebhookStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const zone = aws_route53.HostedZone.fromHostedZoneAttributes(
      this,
      "HostedZone",
      hostedZones.axatol_xyz,
    );

    const certificate = new aws_certificatemanager.Certificate(
      this,
      "Certificate",
      {
        domainName: "webhook.axatol.xyz",
        validation: aws_certificatemanager.CertificateValidation.fromDns(zone),
      },
    );

    const domainName = new DomainName(this, "DomainName", {
      certificate,
      domainName: `webhook.${hostedZones.axatol_xyz.zoneName}`,
    });

    const api = new HttpApi(this, "Api", {
      defaultDomainMapping: { domainName },
    });

    if (!api.url) {
      throw new Error("no value for api url");
    }

    this.output("ApiUrl", api.url);

    api.addRoutes({
      path: "/discord",
      methods: [HttpMethod.OPTIONS, HttpMethod.POST],
      integration: new NotifyDiscordHandler(
        this,
        "NotifyDiscordHandler",
      ).httpIntegration(),
    });
  }
}
