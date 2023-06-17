import { StackProps } from "aws-cdk-lib";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { AssumeCDKDeployRolePolicy } from "~/lib/constructs/iam/AssumeCDKDeployRolePolicy";
import { AssumeCDKLookupRolePolicy } from "~/lib/constructs/iam/AssumeCDKLookupRolePolicy";

export class ManagedPolicyStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const assumeCDKLookupRolePolicy = new AssumeCDKLookupRolePolicy(
      this,
      "AssumeCDKLookupRolePolicy",
    );

    this.output(
      "assumeCDKLookupRolePolicyARN",
      assumeCDKLookupRolePolicy.managedPolicyArn,
    );

    const assumeCDKDeployRolePolicy = new AssumeCDKDeployRolePolicy(
      this,
      "AssumeCDKDeployRolePolicy",
    );

    this.output(
      "assumeCDKDeployRolePolicyARN",
      assumeCDKDeployRolePolicy.managedPolicyArn,
    );
  }
}
