import { StackProps } from "aws-cdk-lib";
import { Effect, PolicyStatement } from "aws-cdk-lib/aws-iam";
import { StringParameter } from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { SSM } from "~/lib/constants";
import { GithubActionsOIDCProvider } from "~/lib/constructs/iam/GithubActionsOIDCProvider";
import { GithubActionsRole } from "~/lib/constructs/iam/GithubActionsRole";
import { arn } from "~/lib/utils/arn";

export class GithubActionsOIDCProviderStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const provider = new GithubActionsOIDCProvider(this, "OIDCProvider");

    new StringParameter(this, "OIDCProviderARNParameter", {
      parameterName: SSM.GithubActionsOIDCProviderARN,
      stringValue: provider.attrArn,
    });

    new GithubActionsRole(this, "IACDeployRole", {
      claims: {
        repositoryOwner: "hans-m-song",
        repository: "iac",
        context: [{ pullRequest: true }],
      },
    }).addToPolicy(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["ssm:GetParameter"],
        resources: [arn(this).parameter(SSM.GithubActionsOIDCProviderARN)],
      }),
    );
  }
}
