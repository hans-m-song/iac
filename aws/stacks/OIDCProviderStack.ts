import { StackProps } from "aws-cdk-lib";
import { StringParameter } from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { SSM } from "~/lib/constants";
import { GithubActionsOIDCProvider } from "~/lib/constructs/iam/GithubOIDCProvider";

export class OIDCProviderStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const ghaOIDCProvider = new GithubActionsOIDCProvider(
      this,
      "GithubActionsOIDCProvider",
    );

    new StringParameter(this, "GithubActionsOIDCProviderARNParameter", {
      parameterName: SSM.GithubActionsOIDCProviderARN,
      stringValue: ghaOIDCProvider.openIdConnectProviderArn,
    });
  }
}
