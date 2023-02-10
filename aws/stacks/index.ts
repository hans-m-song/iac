import "dotenv/config";
import "source-map-support/register";

import { App } from "aws-cdk-lib";

import { GithubActionsOIDCProviderStack } from "./GithubActionsOIDCProviderStack";
import { HostedZoneUpdateStack } from "./HostedZoneUpdateStack";
import { ManagedECRPublicStack } from "./ManagedECRPublicStack";
import { ManagedIAMStack } from "./ManagedIAMStack";

import { hostedZones } from "~/lib/constants";

const app = new App();

new ManagedIAMStack(app, "ManagedIAMStack");

new GithubActionsOIDCProviderStack(app, "GithubActionsOIDCProviderStack");

new HostedZoneUpdateStack(app, "HostedZoneUpdateStack", {
  hostedZones: Object.values(hostedZones),
});

const managedECRPublicStack = new ManagedECRPublicStack(
  app,
  "ManagedECRPublicStack",
  {
    repositories: [
      "github-actions-runner",
      "home-assistant-integrations",
      "huisheng",
    ],
  },
);

managedECRPublicStack.repositories.forEach((repo) =>
  repo.createGithubActionsPublisherRole(),
);

const managedECRPublicForSongmatrixStack = new ManagedECRPublicStack(
  app,
  "SongmatrixStackManagedECRPublic",
  { repositories: ["songmatrix/sync-service"] },
);

managedECRPublicForSongmatrixStack.createGithubActionsPublisherRole(
  "SongMatrixPublisherRole",
  { claims: { repository: "songmatrix/*", contexts: [{ branch: "master" }] } },
);
