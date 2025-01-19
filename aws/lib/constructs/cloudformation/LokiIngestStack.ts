import * as cdk from "aws-cdk-lib";
import * as ecr from "aws-cdk-lib/aws-ecr";
import * as iam from "aws-cdk-lib/aws-iam";
import * as lambda from "aws-cdk-lib/aws-lambda";
import * as logs from "aws-cdk-lib/aws-logs";
import * as logsdest from "aws-cdk-lib/aws-logs-destinations";
import * as ssm from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Stack, StackProps } from "~/lib/cdk/Stack";
import { ECR, SSM } from "~/lib/constants";

export class LokiIngestStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const repo = ecr.Repository.fromRepositoryAttributes(this, "Repository", {
      repositoryName: ECR.GrafanaLambdaPromtail,
      repositoryArn: cdk.Arn.format({
        partition: this.partition,
        service: "ecr",
        region: "ap-southeast-2",
        account: this.account,
        resource: "repository",
        resourceName: ECR.GrafanaLambdaPromtail,
      }),
    });

    const destination = ssm.StringParameter.valueForStringParameter(
      this,
      SSM.LokiLogIngestEndpoint,
    );

    const fn = new lambda.DockerImageFunction(this, "Function", {
      code: lambda.DockerImageCode.fromEcr(repo),
      memorySize: 128,
      timeout: cdk.Duration.seconds(60),
      retryAttempts: 0,
      environment: {
        WRITE_ADDRESS: destination,
        KEEP_STREAM: "false",
        EXTRA_LABELS: ["aws_region", this.region].join(","),
      },
    });

    fn.grantInvoke(new iam.ServicePrincipal("logs.amazonaws.com"));

    fn.addToRolePolicy(
      new iam.PolicyStatement({
        effect: iam.Effect.ALLOW,
        actions: [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:PutSubscriptionFilter",
        ],
        resources: [`arn:${this.partition}:logs:*:*:*`],
      }),
    );

    new ssm.StringParameter(this, "LokiIngestFunctionArn", {
      parameterName: SSM.LogsSubscriptionFilterLambdaDestinationARN,
      stringValue: fn.functionArn,
    });
  }

  static subscribe(scope: Construct, logGroup: logs.ILogGroup) {
    const id = "LokiIngestFunction";
    const stack = cdk.Stack.of(scope);
    const existing = stack.node.tryFindChild(id);

    const fn =
      (existing as lambda.IFunction) ??
      lambda.Function.fromFunctionArn(
        stack,
        id,
        ssm.StringParameter.fromStringParameterName(
          stack,
          "LokiIngestFunctionArn",
          SSM.LogsSubscriptionFilterLambdaDestinationARN,
        ).stringValue,
      );

    logGroup.addSubscriptionFilter("LokiIngest", {
      filterPattern: logs.FilterPattern.all(),
      destination: new logsdest.LambdaDestination(fn),
    });
  }
}
