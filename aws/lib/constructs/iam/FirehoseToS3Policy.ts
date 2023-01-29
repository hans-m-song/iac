import { Arn, ArnFormat, Stack } from "aws-cdk-lib";
import {
  Role,
  RoleProps,
  ServicePrincipal,
  ManagedPolicy,
  ManagedPolicyProps,
  PolicyStatement,
  Effect,
} from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

interface FirehoseToS3PolicyProps extends ManagedPolicyProps {
  bucketArn: string;
}

class FirehoseToS3Policy extends ManagedPolicy {
  constructor(
    scope: Construct,
    id: string,
    { bucketArn, ...props }: FirehoseToS3PolicyProps,
  ) {
    super(scope, id, {
      ...props,
      path: "/service-role/",
    });

    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject",
        ],
        resources: [bucketArn, `${bucketArn}/*`],
      }),
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListShards",
        ],
        resources: [
          Arn.format(
            { service: "kinesis", resource: "stream", resourceName: "*" },
            Stack.of(this),
          ),
        ],
      }),
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["logs:PutLogEvents"],
        resources: [
          Arn.format(
            {
              service: "logs",
              resource: "log-group",
              resourceName: "*:log-stream:*",
              arnFormat: ArnFormat.COLON_RESOURCE_NAME,
            },
            Stack.of(this),
          ),
        ],
      }),
    );
  }
}

export interface FirehoseToS3RoleProps
  extends Omit<RoleProps, "assumedBy" | "path"> {
  bucketArn: string;
}

export class FirehoseToS3Role extends Role {
  constructor(
    scope: Construct,
    id: string,
    { bucketArn, ...props }: FirehoseToS3RoleProps,
  ) {
    super(scope, id, {
      ...props,
      assumedBy: new ServicePrincipal("firehose.amazonaws.com"),
      path: "/service-role/",
    });

    this.addManagedPolicy(
      new FirehoseToS3Policy(this, "Policy", { bucketArn }),
    );
  }
}
