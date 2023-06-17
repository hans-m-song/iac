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
import { XRayAgentStack } from "./XRayAgentStack";

const app = new App();

new AWSServiceRoleStack(app, "AWSServiceRoleStack");

new ManagedPolicyStack(app, "ManagedPolicyStack");

new BoundaryPolicyStack(app, "BoundaryPolicyStack");

new CertificateStack(app, "CertificateStack-USE1", {
  env: { region: Region.NVirginia },
  requests: [{ domainName: "hsong.me" }, { domainName: "axatol.xyz" }],
});

new GithubActionsOIDCProviderStack(app, "GithubActionsOIDCProviderStack");

new HostedZoneUpdateStack(app, "HostedZoneUpdateStack", {
  hostedZones: Object.values(hostedZones),
});

new ManagedECRPublicStack(app, "ManagedECRPublicStack", {
  repositories: [
    ECR.ActionsRunnerBrokerDispatcher,
    ECR.GithubActionsRunner,
    ECR.HomeAssistantIntegrations,
    ECR.Huisheng,
    ECR.JAYD,
  ],
});

new ManagedECRPublicStack(app, "SongMatrixManagedECRPublicStack", {
  repositories: [
    ECR.Songmatrix_DataService,
    ECR.Songmatrix_Gateway,
    ECR.Songmatrix_SyncService,
  ],
});

new XRayAgentStack(app, "XRayAgentStack", {
  env: { region: Region.Singapore },
});

for (const child of app.node.children) {
  (child as Stack).tag();
}
