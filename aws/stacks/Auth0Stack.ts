import { StackProps } from "aws-cdk-lib";
import { OpenIdConnectProvider } from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";

export class Auth0Stack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    new OpenIdConnectProvider(this, "Provider", {
      url: "",
      clientIds: [],
      thumbprints: [],
    });
  }
}
