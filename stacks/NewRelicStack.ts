import { StackProps } from "aws-cdk-lib";
import { CfnDeliveryStream } from "aws-cdk-lib/aws-kinesisfirehose";
import { Bucket } from "aws-cdk-lib/aws-s3";
import { StringParameter } from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { SSM, URI } from "~/lib/constants";
import { FirehoseToS3Role } from "~/lib/constructs/iam/FirehoseToS3Policy";

export class NewRelicStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const licenseKey = StringParameter.valueForStringParameter(
      this,
      SSM.NewRelicLicenseKey,
    );

    const bucket = new Bucket(this, "Bucket");

    const role = new FirehoseToS3Role(this, "FirehoseToS3Role", {
      bucketArn: bucket.bucketArn,
    });

    new CfnDeliveryStream(this, "DeliveryStream", {
      deliveryStreamType: "DirectPut",
      httpEndpointDestinationConfiguration: {
        processingConfiguration: {
          enabled: false,
        },
        endpointConfiguration: {
          name: "New Relic",
          url: URI.NewRelicLogsFirehose,
          accessKey: licenseKey,
        },
        requestConfiguration: {
          contentEncoding: "GZIP",
        },
        bufferingHints: {
          intervalInSeconds: 60,
          sizeInMBs: 1,
        },
        retryOptions: {
          durationInSeconds: 60,
        },
        s3Configuration: {
          compressionFormat: "GZIP",
          bucketArn: bucket.bucketArn,
          roleArn: role.roleArn,
        },
        roleArn: role.roleArn,
      },
    });
  }
}
