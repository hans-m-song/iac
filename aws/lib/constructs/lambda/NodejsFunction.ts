import { Runtime } from "aws-cdk-lib/aws-lambda";
import {
  NodejsFunction as CDKNodejsFunction,
  NodejsFunctionProps as CDKNodejsFunctionProps,
} from "aws-cdk-lib/aws-lambda-nodejs";
import { Construct } from "constructs";
import path from "path";

export interface NodejsFunctionProps extends CDKNodejsFunctionProps {
  // TODO
  // newrelicInstrumentation?: boolean;
  entry: string;
}

export class NodejsFunction extends CDKNodejsFunction {
  constructor(scope: Construct, id: string, { ...props }: NodejsFunctionProps) {
    super(scope, id, {
      runtime: Runtime.NODEJS_16_X,
      ...props,
      entry: path.resolve(process.cwd(), props.entry),
      bundling: {
        minify: true,
        sourceMap: true,
        keepNames: true,
        ...props.bundling,
      },
    });
  }
}
