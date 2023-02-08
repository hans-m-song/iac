import { StackProps } from "aws-cdk-lib";
import { Effect, PolicyStatement } from "aws-cdk-lib/aws-iam";
import { StringParameter } from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { getContext } from "~/lib/cdk/context";
import { Stack } from "~/lib/cdk/Stack";
import { SSM } from "~/lib/constants";
import { GithubActionsOIDCProvider } from "~/lib/constructs/iam/GithubActionsOIDCProvider";
import { GithubActionsRole } from "~/lib/constructs/iam/GithubActionsRole";

export class GithubActionsOIDCProviderStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);
    const ctx = getContext(this);

    const provider = new GithubActionsOIDCProvider(this, "OIDCProvider");

    new StringParameter(this, "OIDCProviderARNParameter", {
      parameterName: SSM.GithubActionsOIDCProviderARN,
      stringValue: provider.attrArn,
    });

    const iacDiffRole = new GithubActionsRole(this, "IACDiffRole", {
      provider,
      claims: {
        repositoryOwner: "hans-m-song",
        repository: "iac",
        contexts: [{ pullRequest: true }, { branch: "*" }],
      },
    });

    iacDiffRole.addToPolicy(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["sts:AssumeRole"],
        resources: [ctx.bootstrapRoleARN("lookup-role")],
      }),
    );

    this.output("IACDiffRoleARN", iacDiffRole.roleArn);

    new StringParameter(this, "GithubActionsIACDiffRoleARNParameter", {
      parameterName: SSM.GithubActionsIACDiffRoleARN,
      stringValue: iacDiffRole.roleArn,
    });

    const iacDeployRole = new GithubActionsRole(this, "IACDeployRole", {
      provider,
      claims: {
        repositoryOwner: "hans-m-song",
        repository: "iac",
        contexts: [{ pullRequest: true }],
        // contexts: [{ branch: "master" }],
      },
    });

    iacDeployRole.addToPolicy(
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

    this.output("IACDeployRoleARN", iacDeployRole.roleArn);

    new StringParameter(this, "GithubActionsIACDeployRoleARNParameter", {
      parameterName: SSM.GithubActionsIACDeployRoleARN,
      stringValue: iacDeployRole.roleArn,
    });
  }
}
