import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";

export type StackProps = cdk.StackProps;

export class Stack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    const stackName = props?.stackName ?? id;

    super(scope, id, {
      ...props,
      stackName,
    });
  }

  tag() {
    Object.entries(this.tags.tagValues()).forEach(([name, value]) => {
      cdk.Tags.of(this).add(name, value);
    });
  }

  output(name: string, value: string) {
    return new cdk.CfnOutput(this, name, { value });
  }
}
