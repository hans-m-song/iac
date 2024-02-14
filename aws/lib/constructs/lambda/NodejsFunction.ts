import * as lambda from "aws-cdk-lib/aws-lambda";
import * as nodejs from "aws-cdk-lib/aws-lambda-nodejs";
import { Construct } from "constructs";
import path from "path";

import { SingletonConstruct } from "~/lib/cdk/SingletonConstruct";

export interface NodejsFunctionProps
  extends Omit<nodejs.NodejsFunctionProps, "runtime" | "entry"> {
  entry: string;
}

export class NodejsFunction extends nodejs.NodejsFunction {
  static singleton = new SingletonConstruct(NodejsFunction);

  constructor(scope: Construct, id: string, props: NodejsFunctionProps) {
    const overriddenProps: nodejs.NodejsFunctionProps = {
      runtime: lambda.Runtime.NODEJS_18_X,
      handler: "index.handler",
      ...props,
      entry: path.resolve(process.cwd(), "handlers", props.entry),
      bundling: {
        externalModules: ["@aws-sdk/*", "newrelic"],
        keepNames: true,
        minify: true,
        sourcesContent: false,
        sourceMap: true,
        ...props.bundling,
      },
    };

    super(scope, id, overriddenProps);
  }

  static asSingleton(scope: Construct, id: string, props: NodejsFunctionProps) {
    return new SingletonConstruct(NodejsFunction).get(scope, id, props);
  }
}
