import { CfnOIDCProvider, CfnOIDCProviderProps } from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { Domain, URI } from "~/lib/constants";

// https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
// https://gist.github.com/guitarrapc/8e6b68f21bc1eef8e7b66bde477d5859
// openid_config=$( curl https://token.actions.githubusercontent.com/.well-known/openid-configuration )
// jwks_uri=$( echo $openid_config | jq -rM '.jwks_uri' )
// server_name=$( echo $jwks_uri | sed -e 's|https://||' -e 's|/.*$||' )
// cert_data=$( openssl s_client -servername $server_name -showcerts -connect $server_name:443 < /dev/null 2>/dev/null )
// certs=$( echo $cert_data | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' )

export class GithubActionsOIDCProvider extends CfnOIDCProvider {
  constructor(scope: Construct, id: string, props?: CfnOIDCProviderProps) {
    super(scope, id, {
      ...props,
      url: URI.GithubActionsToken,
      clientIdList: [Domain.AWSSecurityTokenService],
      thumbprintList: [
        "6938fd4d98bab03faadb97b34396831e3780aea1",
        "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
      ],
    });
  }
}
