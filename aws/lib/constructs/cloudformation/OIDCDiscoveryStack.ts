import * as cm from "aws-cdk-lib/aws-certificatemanager";
import * as cf from "aws-cdk-lib/aws-cloudfront";
import * as cfo from "aws-cdk-lib/aws-cloudfront-origins";
import * as iam from "aws-cdk-lib/aws-iam";
import * as r53 from "aws-cdk-lib/aws-route53";
import * as r53t from "aws-cdk-lib/aws-route53-targets";
import * as s3 from "aws-cdk-lib/aws-s3";
import * as ssm from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Stack, StackProps } from "~/lib/cdk/Stack";
import { SSM } from "~/lib/constants";

export interface OIDCDiscoveryStackProps extends StackProps {
  zoneName: string;
  hostedZoneId: string;
  issuerDomainName: string;
}

export class OIDCDiscoveryStack extends Stack {
  bucket: s3.Bucket;
  distribution: cf.Distribution;

  constructor(
    scope: Construct,
    id: string,
    {
      zoneName,
      hostedZoneId,
      issuerDomainName,
      ...props
    }: OIDCDiscoveryStackProps,
  ) {
    super(scope, id, props);

    this.bucket = new s3.Bucket(this, "Bucket", {
      bucketName: issuerDomainName,
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
    });

    this.bucket.addToResourcePolicy(
      new iam.PolicyStatement({
        effect: iam.Effect.DENY,
        actions: ["s3:GetObject"],
        resources: [`${this.bucket.bucketArn}/private/*`],
        principals: [new iam.AnyPrincipal()],
      }),
    );

    const certificateArn = ssm.StringParameter.valueForStringParameter(
      this,
      `${SSM.CertificateParameterPrefix}/${zoneName}/certificate_arn`,
    );

    const certificate = cm.Certificate.fromCertificateArn(
      this,
      "Certificate",
      certificateArn,
    );

    this.distribution = new cf.Distribution(this, "Distribution", {
      certificate,
      domainNames: [issuerDomainName],
      defaultBehavior: {
        origin: cfo.S3BucketOrigin.withOriginAccessControl(this.bucket, {}),
        compress: true,
        allowedMethods: cf.AllowedMethods.ALLOW_GET_HEAD,
        cachedMethods: cf.CachedMethods.CACHE_GET_HEAD,
        cachePolicy: cf.CachePolicy.CACHING_OPTIMIZED,
        viewerProtocolPolicy: cf.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
      },
    });

    const hostedZone = r53.HostedZone.fromHostedZoneAttributes(
      this,
      "HostedZone",
      { zoneName, hostedZoneId },
    );

    new r53.ARecord(this, "DomainName", {
      zone: hostedZone,
      recordName: `${issuerDomainName}.`,
      target: r53.RecordTarget.fromAlias(
        new r53t.CloudFrontTarget(this.distribution),
      ),
    });
  }
}
