import { CfnOutput } from "aws-cdk-lib";
import { Construct } from "constructs";

export interface OutputMap {
  [name: string]: string;
}

export class Outputs {
  outputs: CfnOutput[];

  constructor(scope: Construct, outputs: OutputMap) {
    this.outputs = Object.entries(outputs).map(
      ([name, value]) =>
        new CfnOutput(scope, `${name}-Output`, { exportName: name, value }),
    );
  }
}
