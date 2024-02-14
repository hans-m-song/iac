import * as cdk from "aws-cdk-lib";
import * as ssm from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { SSM } from "~/lib/constants";
import { AssumeCDKDeployRolePolicy } from "~/lib/constructs/iam/AssumeCDKDeployRolePolicy";
import { AssumeCDKLookupRolePolicy } from "~/lib/constructs/iam/AssumeCDKLookupRolePolicy";
import { LambdaBoundaryPolicy } from "~/lib/constructs/iam/LambdaBoundaryPolicy";
import { UserBoundaryPolicy } from "~/lib/constructs/iam/UserBoundaryPolicy";

export class ManagedPolicyStack extends Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const assumeCDKLookupRolePolicy = new AssumeCDKLookupRolePolicy(
      this,
      "AssumeCDKLookupRolePolicy",
    );

    this.output(
      "AssumeCDKLookupRolePolicyARN",
      assumeCDKLookupRolePolicy.managedPolicyArn,
    );

    const assumeCDKDeployRolePolicy = new AssumeCDKDeployRolePolicy(
      this,
      "AssumeCDKDeployRolePolicy",
    );

    this.output(
      "AssumeCDKDeployRolePolicyARN",
      assumeCDKDeployRolePolicy.managedPolicyArn,
    );

    const lambdaBoundaryPolicy = new LambdaBoundaryPolicy(
      this,
      "LambdaBoundaryPolicy",
    );

    this.output(
      "LambdaBoundaryPolicyARN",
      lambdaBoundaryPolicy.managedPolicyArn,
    );

    new ssm.StringParameter(this, "LambdaBoundaryPolicyARNParameter", {
      parameterName: SSM.IAMLambdaBoundaryPolicyARN,
      stringValue: lambdaBoundaryPolicy.managedPolicyArn,
    });

    const userBoundaryPolicy = new UserBoundaryPolicy(
      this,
      "UserBoundaryPolicy",
    );

    this.output("UserBoundaryPolicyARN", userBoundaryPolicy.managedPolicyArn);

    new ssm.StringParameter(this, "UserBoundaryPolicyARNParameter", {
      parameterName: SSM.IAMUserBoundaryPolicyARN,
      stringValue: userBoundaryPolicy.managedPolicyArn,
    });
  }
}
