import * as cdk from "aws-cdk-lib";
import * as ssm from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { SSM } from "~/lib/constants";
import { LambdaBoundaryPolicy } from "~/lib/constructs/iam/LambdaBoundaryPolicy";
import { UserBoundaryPolicy } from "~/lib/constructs/iam/UserBoundaryPolicy";

export class BoundaryPolicyStack extends Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const lambdaBoundaryPolicy = new LambdaBoundaryPolicy(
      this,
      "LambdaBoundaryPolicy",
    );

    new ssm.StringParameter(this, "LambdaBoundaryPolicyARNParameter", {
      parameterName: SSM.IAMLambdaBoundaryPolicyARN,
      stringValue: lambdaBoundaryPolicy.managedPolicyArn,
    });

    const userBoundaryPolicy = new UserBoundaryPolicy(
      this,
      "UserBoundaryPolicy",
    );

    new ssm.StringParameter(this, "UserBoundaryPolicyARNParameter", {
      parameterName: SSM.IAMUserBoundaryPolicyARN,
      stringValue: userBoundaryPolicy.managedPolicyArn,
    });
  }
}
