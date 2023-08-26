import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";

import { getContext } from "./context";

export type StackProps = cdk.StackProps;

export class Stack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    const context = getContext(scope);
    const stackName = props?.stackName ?? id;

    super(scope, id, {
      ...props,
      stackName,
      tags: {
        StackName: stackName,
        GitRepository: context.repositoryUrl,
        Purpose: "Infrastructure",
        ...props?.tags,
      },
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
