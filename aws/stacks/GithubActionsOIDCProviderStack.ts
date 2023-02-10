import { StackProps } from "aws-cdk-lib";
import { CfnPublicRepository } from "aws-cdk-lib/aws-ecr";
import { Effect, PolicyStatement } from "aws-cdk-lib/aws-iam";
import { StringParameter } from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { getContext } from "~/lib/cdk/context";
import { Stack } from "~/lib/cdk/Stack";
import { SSM } from "~/lib/constants";
import { ECRPublicPublisherPolicy } from "~/lib/constructs/iam/ECRPublicPublisherPolicy";
import { GithubActionsOIDCProvider } from "~/lib/constructs/iam/GithubActionsOIDCProvider";
import {
  GithubActionsRole,
  GithubActionsRoleProps,
} from "~/lib/constructs/iam/GithubActionsRole";

export interface CreateGithubActionsECRPublisherRoleProps
  extends GithubActionsRoleProps {
  repositories: CfnPublicRepository[];
}

export class GithubActionsOIDCProviderStack extends Stack {
  provider: GithubActionsOIDCProvider;

  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);
    const ctx = getContext(this);

    const provider = new GithubActionsOIDCProvider(this, "OIDCProvider");
    this.provider = provider;

    new StringParameter(this, "OIDCProviderARNParameter", {
      parameterName: SSM.GithubActionsOIDCProviderARN,
      stringValue: provider.attrArn,
    });

    const iacDiffRole = new GithubActionsRole(this, "IACDiffRole", {
      providerArn: provider.attrArn,
      claims: {
        repository: "hans-m-song/iac",
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
      providerArn: provider.attrArn,
      claims: {
        repository: "hans-m-song/iac",
        contexts: [{ environment: "aws" }],
        actors: ["hans-m-song"],
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

  static createECRPublisherRole(
    scope: Construct,
    id: string,
    { repositories, ...props }: CreateGithubActionsECRPublisherRoleProps,
  ) {
    const role = new GithubActionsRole(scope, id, props);

    role.addManagedPolicy(
      new ECRPublicPublisherPolicy(role, "PublisherPolicy", { repositories }),
    );

    return role;
  }
}
