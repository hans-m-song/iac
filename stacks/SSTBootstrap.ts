import { App, aws_s3, aws_ssm, RemovalPolicy, Stack, Tags } from "aws-cdk-lib";

const app = new App();
const stack = new Stack(app, "SSTBootstrap");

const bucket = new aws_s3.Bucket(stack, "Bucket", {
  encryption: aws_s3.BucketEncryption.S3_MANAGED,
  accessControl: aws_s3.BucketAccessControl.PRIVATE,
  autoDeleteObjects: true,
  removalPolicy: RemovalPolicy.DESTROY,
  blockPublicAccess: aws_s3.BlockPublicAccess.BLOCK_ALL,
  publicReadAccess: false,
});

new aws_ssm.StringParameter(stack, "SSTBootstrapVersion", {
  parameterName: "/sst/bootstrap/version",
  stringValue: "3",
});

new aws_ssm.StringParameter(stack, "SSTBootstrapStackName", {
  parameterName: "/sst/bootstrap/stack-name",
  stringValue: stack.stackName,
});

new aws_ssm.StringParameter(stack, "SSTBootstrapBucketName", {
  parameterName: "/sst/bootstrap/bucket-name",
  stringValue: bucket.bucketName,
});

Tags.of(app).add("Stack", stack.stackName);
