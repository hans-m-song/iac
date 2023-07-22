import { CfnOIDCProvider, CfnOIDCProviderProps } from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { Domain, URI } from "~/lib/constants";

export class TerraformOIDCProvider extends CfnOIDCProvider {
  constructor(scope: Construct, id: string, props?: CfnOIDCProviderProps) {
    super(scope, id, {
      ...props,
      url: URI.Terraform,
      clientIdList: [Domain.TerraformAudience],
      thumbprintList: ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"],
    });
  }
}
