import { StackProps } from "aws-cdk-lib";
import { StringParameter } from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { SSM } from "~/lib/constants";
import { ExecutionBoundaryPolicy } from "~/lib/constructs/iam/ExecutionBoundaryPolicy";
import { UserBoundaryPolicy } from "~/lib/constructs/iam/UserBoundaryPolicy";

export class ManagedIAMStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const executionBoundaryPolicy = new ExecutionBoundaryPolicy(
      this,
      "ExecutionBoundaryPolicy",
    );

    new StringParameter(this, "ExecutionBoundaryPolicyARNParameter", {
      parameterName: SSM.ExecutionBoundaryPolicyARN,
      stringValue: executionBoundaryPolicy.managedPolicyArn,
    });

    const userBoundaryPolicy = new UserBoundaryPolicy(
      this,
      "UserBoundaryPolicy",
      { executionBoundaryPolicy },
    );

    new StringParameter(this, "UserBoundaryPolicyARNParameter", {
      parameterName: SSM.UserBoundaryPolicyARN,
      stringValue: userBoundaryPolicy.managedPolicyArn,
    });
  }
}
