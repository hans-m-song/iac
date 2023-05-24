import { Stack } from "aws-cdk-lib";
import {
  Effect,
  ManagedPolicy,
  PolicyStatement,
  Role,
  RoleProps,
  ServicePrincipal,
} from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { arn } from "~/lib/utils/arn";

export class CloudTrailLoggingRole extends Role {
  constructor(
    scope: Construct,
    id: string,
    props?: Omit<RoleProps, "assumedBy">,
  ) {
    super(scope, id, {
      ...props,
      assumedBy: new ServicePrincipal("cloudtrail.amazonaws.com"),
    });

    const stack = Stack.of(this);

    const logStreamARN = arn("*").cw.logstream(
      `aws-cloudtrail-logs-${stack.account}`,
      `${stack.account}_CloudTrail_*`,
    );

    const policy = new ManagedPolicy(this, "Policy", {
      statements: [
        new PolicyStatement({
          effect: Effect.ALLOW,
          actions: ["logs:CreateLogStream", "logs:PutLogEvents"],
          resources: [logStreamARN],
        }),
      ],
    });

    this.addManagedPolicy(policy);
  }
}
