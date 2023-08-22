import { HttpLambdaIntegration } from "@aws-cdk/aws-apigatewayv2-integrations-alpha";
import { aws_lambda, aws_lambda_nodejs, aws_logs } from "aws-cdk-lib";
import { Construct } from "constructs";
import path from "path";

export interface NodejsFunctionProps
  extends Omit<aws_lambda_nodejs.NodejsFunctionProps, "runtime" | "entry"> {
  entry: string;
}

export class NodejsFunction extends aws_lambda_nodejs.NodejsFunction {
  constructor(scope: Construct, id: string, props: NodejsFunctionProps) {
    const overriddenProps: aws_lambda_nodejs.NodejsFunctionProps = {
      runtime: aws_lambda.Runtime.NODEJS_18_X,
      logRetention: aws_logs.RetentionDays.ONE_YEAR,
      handler: "index.handler",
      ...props,
      entry: path.resolve(process.cwd(), "handlers", props.entry),
      bundling: {
        externalModules: ["@aws-sdk/*", "newrelic"],
        keepNames: true,
        minify: true,
        sourcesContent: false,
        ...props.bundling,
      },
    };

    super(scope, id, overriddenProps);
  }

  httpIntegration(id?: string) {
    return new HttpLambdaIntegration(id ?? `${this.node.id}Integration`, this);
  }
}
