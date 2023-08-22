import "dotenv/config";
import "source-map-support/register";

import { App } from "aws-cdk-lib";

import { Stack } from "~/lib/cdk/Stack";
import { ECR, Region, hostedZones } from "~/lib/constants";

import { AWSServiceRoleStack } from "./AWSServiceRoleStack";
import { BoundaryPolicyStack } from "./BoundaryPolicyStack";
import { CertificateStack } from "./CertificateStack";
import { GithubActionsOIDCProviderStack } from "./GithubActionsOIDCProviderStack";
import { HostedZoneUpdateStack } from "./HostedZoneUpdateStack";
import { ManagedECRPublicStack } from "./ManagedECRPublicStack";
import { ManagedPolicyStack } from "./ManagedPolicyStack";
import { TerraformBackendStack } from "./TerraformBackendStack";

const app = new App();

new AWSServiceRoleStack(app, "AWSServiceRoleStack", {
  env: { region: Region.Sydney },
});

new ManagedPolicyStack(app, "ManagedPolicyStack", {
  env: { region: Region.Sydney },
});

new BoundaryPolicyStack(app, "BoundaryPolicyStack", {
  env: { region: Region.Sydney },
});

new CertificateStack(app, "CertificateStack-USE1", {
  env: { region: Region.NVirginia },
  requests: [
    { domainName: "hsong.me" },
    { domainName: "axatol.xyz", alternateNames: ["*.axatol.xyz"] },
  ],
});

new GithubActionsOIDCProviderStack(app, "GithubActionsOIDCProviderStack", {
  env: { region: Region.Sydney },
});

new HostedZoneUpdateStack(app, "HostedZoneUpdateStack", {
  env: { region: Region.Sydney },
  hostedZones: Object.values(hostedZones),
});

new ManagedECRPublicStack(app, "ManagedECRPublicStack", {
  env: { region: Region.Sydney },
  repositories: Object.values(ECR),
});

new TerraformBackendStack(app, "TerraformBackendStack", {
  env: { region: Region.Sydney },
});

for (const child of app.node.children) {
  (child as Stack).tag();
}
