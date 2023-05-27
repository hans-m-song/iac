import { StackProps } from "aws-cdk-lib";
import { StringParameter } from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { SSM } from "~/lib/constants";
import { LambdaBoundaryPolicy } from "~/lib/constructs/iam/LambdaBoundaryPolicy";
import { UserBoundaryPolicy } from "~/lib/constructs/iam/UserBoundaryPolicy";

export class BoundaryPolicyStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const lambdaBoundaryPolicy = new LambdaBoundaryPolicy(
      this,
      "LambdaBoundaryPolicy",
    );

    new StringParameter(this, "LambdaBoundaryPolicyARNParameter", {
      parameterName: SSM.LambdaBoundaryPolicyARN,
      stringValue: lambdaBoundaryPolicy.managedPolicyArn,
    });

    const userBoundaryPolicy = new UserBoundaryPolicy(
      this,
      "UserBoundaryPolicy",
    );

    new StringParameter(this, "UserBoundaryPolicyARNParameter", {
      parameterName: SSM.UserBoundaryPolicyARN,
      stringValue: userBoundaryPolicy.managedPolicyArn,
    });
  }
}
