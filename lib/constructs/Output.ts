import { CfnOutput } from "aws-cdk-lib";
import { Construct } from "constructs";

export interface OutputMap {
  [name: string]: string;
}

export class Outputs {
  outputs: CfnOutput[];

  constructor(scope: Construct, outputs: OutputMap) {
    this.outputs = [];

    Object.entries(outputs).forEach(([name, value]) =>
      this.add(scope, name, value),
    );
  }

  add(scope: Construct, exportName: string, value: string) {
    const output = new CfnOutput(scope, `${exportName}-Output`, {
      exportName,
      value,
    });

    this.outputs.push(output);

    return output;
  }
}
