import "dotenv/config";
import "source-map-support/register";

import { App } from "aws-cdk-lib";

import { GithubActionsOIDCProviderStack } from "./GithubActionsOIDCProviderStack";
import { HostedZoneUpdateStack } from "./HostedZoneUpdateStack";
import { ManagedECRPublicStack } from "./ManagedECRPublicStack";
import { ManagedIAMStack } from "./ManagedIAMStack";

import { ECR, hostedZones } from "~/lib/constants";

const app = new App();

new ManagedIAMStack(app, "ManagedIAMStack");

new GithubActionsOIDCProviderStack(app, "GithubActionsOIDCProviderStack");

new HostedZoneUpdateStack(app, "HostedZoneUpdateStack", {
  hostedZones: Object.values(hostedZones),
});

new ManagedECRPublicStack(app, "ManagedECRPublicStack", {
  repositories: [
    ECR.GithubActionsRunner,
    ECR.HomeAssistantIntegrations,
    ECR.Huisheng,
  ],
});

new ManagedECRPublicStack(app, "SongMatrixManagedECRPublicStack", {
  repositories: [
    ECR.Songmatrix_DataService,
    ECR.Songmatrix_Gateway,
    ECR.Songmatrix_SyncService,
  ],
});
