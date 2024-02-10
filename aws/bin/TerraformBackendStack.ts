import * as cdk from "aws-cdk-lib";
import * as ddb from "aws-cdk-lib/aws-dynamodb";
import * as iam from "aws-cdk-lib/aws-iam";
import * as s3 from "aws-cdk-lib/aws-s3";
import * as ssm from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { SSM } from "~/lib/constants";

export class TerraformBackendStack extends Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const stateBucket = new s3.Bucket(this, "StateBucket", {
      bucketName: `terraform-state-${this.account}`,
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      encryption: s3.BucketEncryption.S3_MANAGED,
      objectLockEnabled: true,
    });

    this.output("StateBucketName", stateBucket.bucketName);

    new ssm.StringParameter(this, "StateBucketNameParameter", {
      parameterName: SSM.TerraformStateBucketName,
      stringValue: stateBucket.bucketName,
    });

    const lockTable = new ddb.Table(this, "LockTable", {
      tableName: "terraform-state-lock",
      partitionKey: { name: "LockID", type: ddb.AttributeType.STRING },
      billingMode: ddb.BillingMode.PAY_PER_REQUEST,
    });

    this.output("LockTableName", lockTable.tableName);

    new ssm.StringParameter(this, "LockTableNameParameter", {
      parameterName: SSM.TerraformLockTableName,
      stringValue: lockTable.tableName,
    });

    const policy = new iam.ManagedPolicy(this, "TerraformBackendPolicy");
    stateBucket.grantReadWrite(policy);
    lockTable.grantReadWriteData(policy);

    this.output("PolicyArn", policy.managedPolicyArn);

    new ssm.StringParameter(this, "TerraformBackendPolicyParameter", {
      parameterName: SSM.IAMTerraformBackendPolicyARN,
      stringValue: policy.managedPolicyArn,
    });
  }
}
