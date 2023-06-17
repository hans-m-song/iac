import {
  Effect,
  ManagedPolicy,
  ManagedPolicyProps,
  PolicyStatement,
} from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { getContext } from "~/lib/cdk/context";

export class AssumeCDKDeployRolePolicy extends ManagedPolicy {
  constructor(scope: Construct, id: string, props?: ManagedPolicyProps) {
    super(scope, id, props);
    const ctx = getContext(this);

    this.addStatements(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["sts:AssumeRole"],
        resources: [
          ctx.bootstrapRoleARN("lookup-role"),
          ctx.bootstrapRoleARN("deploy-role"),
          ctx.bootstrapRoleARN("image-publishing-role"),
          ctx.bootstrapRoleARN("file-publishing-role"),
          ctx.bootstrapRoleARN("cfn-exec-role"),
        ],
      }),
    );
  }
}
