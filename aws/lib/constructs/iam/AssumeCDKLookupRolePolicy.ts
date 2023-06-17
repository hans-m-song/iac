import {
  Effect,
  ManagedPolicy,
  ManagedPolicyProps,
  PolicyStatement,
} from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { getContext } from "~/lib/cdk/context";

export class AssumeCDKLookupRolePolicy extends ManagedPolicy {
  constructor(scope: Construct, id: string, props?: ManagedPolicyProps) {
    super(scope, id, props);
    const ctx = getContext(this);

    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["sts:AssumeRole"],
        resources: [ctx.bootstrapRoleARN("lookup-role")],
      }),
    );
  }
}
