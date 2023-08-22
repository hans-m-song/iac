import { StackProps } from "aws-cdk-lib";
import {
  Certificate,
  CertificateValidation,
} from "aws-cdk-lib/aws-certificatemanager";
import { HostedZone, IHostedZone } from "aws-cdk-lib/aws-route53";
import { StringParameter } from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { Region, SSM, hostedZones } from "~/lib/constants";
import { CrossRegionStringParameterCreator } from "~/lib/constructs/ssm/CrossRegionStringParameter";
import { urlToPascalCase } from "~/lib/utils/string";

export interface CertificateRequest {
  domainName: string;
  alternateNames?: string[];
}

export interface CertificateStackProps extends StackProps {
  requests: CertificateRequest[];
}

export class CertificateStack extends Stack {
  hostedZones: Record<string, IHostedZone> = {};
  certificates: Record<string, Certificate> = {};

  constructor(
    scope: Construct,
    id: string,
    { requests, ...props }: CertificateStackProps,
  ) {
    super(scope, id, props);

    requests.forEach((request) => {
      this.certificate(request);
    });
  }

  certificate(request: CertificateRequest) {
    const { domainName, alternateNames } = request;

    const invalidAlternateNames = alternateNames?.filter(
      (name) => !name.endsWith(domainName),
    );

    if (invalidAlternateNames && invalidAlternateNames.length > 0) {
      throw new Error(
        `invalid alternate names: ${invalidAlternateNames.join(", ")}`,
      );
    }

    const zone = this.hostedZone(domainName);

    if (!zone) {
      throw new Error(
        `no hosted zone attributes matching domain name: ${domainName}`,
      );
    }

    if (this.certificates[domainName]) {
      return this.certificates[domainName];
    }

    this.certificates[domainName] = new Certificate(
      this,
      `Certificate${urlToPascalCase(domainName)}`,
      {
        domainName,
        validation: CertificateValidation.fromDns(zone),
        subjectAlternativeNames: alternateNames,
      },
    );

    new StringParameter(this, `Parameter${urlToPascalCase(domainName)}`, {
      parameterName: `${SSM.CertificateParameterPrefix}/${domainName}/certificate_arn`,
      stringValue: this.certificates[domainName].certificateArn,
    });

    if (this.region !== Region.Sydney) {
      new CrossRegionStringParameterCreator(
        this,
        `ParameterAPSE2${urlToPascalCase(domainName)}`,
        {
          parameterName: `${SSM.CertificateParameterPrefix}/${domainName}/certificate_arn`,
          region: Region.Sydney,
          stringValue: this.certificates[domainName].certificateArn,
        },
      );
    }
  }

  hostedZone(domainName: string) {
    const attributes = Object.values(hostedZones).find((zone) =>
      domainName.endsWith(zone.zoneName),
    );

    if (!attributes) {
      return null;
    }

    if (this.hostedZones[attributes.zoneName]) {
      return this.hostedZones[attributes.zoneName];
    }

    this.hostedZones[attributes.zoneName] = HostedZone.fromHostedZoneAttributes(
      this,
      `HostedZone${urlToPascalCase(domainName)}`,
      attributes,
    );

    return this.hostedZones[attributes.zoneName];
  }
}
