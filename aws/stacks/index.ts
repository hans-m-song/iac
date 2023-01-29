import "dotenv/config";
import "source-map-support/register";

import { App } from "aws-cdk-lib";

import { HostedZoneUpdateStack } from "./HostedZoneUpdateStack";
import { ManagedECRPublicStack } from "./ManagedECRPublicStack";

const app = new App();

new HostedZoneUpdateStack(app, "HostedZoneUpdateStack");

new ManagedECRPublicStack(app, "ManagedECRPublicStack", {
  repositories: [
    "github-actions-runner",
    "home-assistant-integrations",
    "huisheng",
  ],
});

new ManagedECRPublicStack(app, "ManagedECRPublicForSongmatrixStack", {
  prefix: "songmatrix",
  repositories: ["sync-service"],
});
