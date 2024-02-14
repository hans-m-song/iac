import * as acm from "aws-cdk-lib/aws-certificatemanager";
import * as cf from "aws-cdk-lib/aws-cloudfront";
import * as cfo from "aws-cdk-lib/aws-cloudfront-origins";
import * as r53 from "aws-cdk-lib/aws-route53";
import * as r53t from "aws-cdk-lib/aws-route53-targets";
import * as s3 from "aws-cdk-lib/aws-s3";
import * as ssm from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Stack, StackProps } from "~/lib/cdk/Stack";
import { SSM } from "~/lib/constants";

export interface OIDCDiscoveryStackProps extends StackProps {
  zoneName: string;
  issuerDomainName: string;
}

export class OIDCDiscoveryStack extends Stack {
  bucket: s3.Bucket;
  originAccessIdentity: cf.OriginAccessIdentity;
  distribution: cf.Distribution;

  constructor(
    scope: Construct,
    id: string,
    { zoneName, issuerDomainName, ...props }: OIDCDiscoveryStackProps,
  ) {
    super(scope, id, props);

    this.bucket = new s3.Bucket(this, "Bucket");

    this.originAccessIdentity = new cf.OriginAccessIdentity(this, "Identity");
    this.bucket.grantRead(this.originAccessIdentity);

    const certificate = acm.Certificate.fromCertificateArn(
      this,
      "Certificate",
      ssm.StringParameter.valueForStringParameter(
        this,
        `${SSM.CertificateParameterPrefix}/${zoneName}/certificate_arn`,
      ),
    );

    this.distribution = new cf.Distribution(this, "Distribution", {
      certificate,
      domainNames: [issuerDomainName],
      defaultBehavior: {
        origin: new cfo.S3Origin(this.bucket, {
          originAccessIdentity: this.originAccessIdentity,
        }),
      },
    });

    const hostedZone = r53.HostedZone.fromLookup(this, "HostedZone", {
      domainName: zoneName,
    });

    new r53.ARecord(this, "DomainName", {
      zone: hostedZone,
      recordName: `${issuerDomainName}.`,
      target: r53.RecordTarget.fromAlias(
        new r53t.CloudFrontTarget(this.distribution),
      ),
    });
  }
}
