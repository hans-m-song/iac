import { CfnOutput, Stack as CDKStack, StackProps } from "aws-cdk-lib";
import { Construct } from "constructs";

import { getContext } from "./context";

export class Stack extends CDKStack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    const context = getContext(scope);
    const stackName = props?.stackName ?? id;

    const stackProps: StackProps = {
      ...props,
      stackName,
      tags: {
        StackName: stackName,
        GitRepository: context.repositoryUrl,
        Purpose: "Infrastructure",
        ...props?.tags,
      },
    };

    super(scope, id, stackProps);
  }

  output(exportName: string, value: string) {
    return new CfnOutput(this, exportName, { exportName, value });
  }
}
