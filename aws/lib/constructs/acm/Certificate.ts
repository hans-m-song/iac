import {
  Certificate,
  CertificateProps,
  CertificateValidation,
} from "aws-cdk-lib/aws-certificatemanager";
import { HostedZone, IHostedZone } from "aws-cdk-lib/aws-route53";
import { Construct } from "constructs";

import { hostedZones } from "~/lib/constants";

export type ValidatedCertificateProps = Omit<CertificateProps, "validation">;

export class ValidatedCertificate extends Construct {
  hostedZone: IHostedZone;
  certificate: Certificate;

  constructor(scope: Construct, id: string, props: ValidatedCertificateProps) {
    super(scope, id);

    const attributes = Object.values(hostedZones).find((zone) =>
      props.domainName.endsWith(zone.zoneName),
    );

    if (!attributes) {
      throw new Error(
        `no matching hosted zone available for domain name: ${props.domainName}`,
      );
    }

    this.hostedZone = HostedZone.fromHostedZoneAttributes(
      this,
      "HostedZone",
      attributes,
    );

    this.certificate = new Certificate(this, "Certificate", {
      ...props,
      validation: CertificateValidation.fromDns(this.hostedZone),
    });
  }

  get certificateArn() {
    return this.certificate.certificateArn;
  }
}
