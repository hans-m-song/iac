import { aws_iam, Arn, Stack, aws_eks } from "aws-cdk-lib";
import { Construct } from "constructs";

export class EKSConnectorAgentPolicy extends aws_iam.ManagedPolicy {
  constructor(scope: Construct) {
    super(scope, `${scope.node.id}-Policy`, {
      statements: [
        new aws_iam.PolicyStatement({
          sid: "SSMControlChannel",
          effect: aws_iam.Effect.ALLOW,
          actions: ["ssmmessages:CreateControlChannel"],
          resources: [
            Arn.format(
              { service: "eks", resource: "cluster" },
              Stack.of(scope),
            ),
          ],
        }),
        new aws_iam.PolicyStatement({
          sid: "SSMDataplaneOperations",
          effect: aws_iam.Effect.ALLOW,
          actions: [
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenDataChannel",
            "ssmmessages:OpenControlChannel",
          ],
          resources: ["*"],
        }),
      ],
    });
  }
}

export class EKSConnectorAgentRole extends aws_iam.Role {
  constructor(scope: Construct) {
    super(scope, `${scope.node.id}-Role`, {
      assumedBy: new aws_iam.ServicePrincipal("ssm.amazonaws.com"),
    });

    this.addManagedPolicy(new EKSConnectorAgentPolicy(scope));
    this.addManagedPolicy(
      aws_iam.ManagedPolicy.fromAwsManagedPolicyName("AmazonEKSClusterPolicy"),
    );
  }
}
