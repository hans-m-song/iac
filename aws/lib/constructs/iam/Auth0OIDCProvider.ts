import { CfnOIDCProvider, CfnOIDCProviderProps } from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { Domain, URI } from "~/lib/constants";

export class Auth0OIDCProvider extends CfnOIDCProvider {
  constructor(scope: Construct, id: string, props?: CfnOIDCProviderProps) {
    super(scope, id, {
      ...props,
      url: URI.Auth0Tenant,
      clientIdList: [Domain.AWS],
      thumbprintList: [
        "49888e64a6dab114df76bb789e1f08b2303cd92e",
        "091e8ea1b256a312962af6c140c0fbf079a407b3",
        "151682f5218c0a511c28f4060a73b9ca78ce9a53",
        "933c6ddee95c9c41a40f9f50493d82be03ad87bf",
      ],
    });
  }
}
