import "dotenv/config";
import "source-map-support/register";

import { App } from "aws-cdk-lib";

import { HostedZoneUpdateStack } from "./HostedZoneUpdateStack";
import { ManagedECRPublicStack } from "./ManagedECRPublicStack";
import { OIDCProviderStack } from "./OIDCProviderStack";

const app = new App();

new HostedZoneUpdateStack(app, "HostedZoneUpdateStack", {
  hostedZones: [
    { zoneName: "hsong.me", hostedZoneId: "Z09233301OJXCBONJC133" },
    { zoneName: "axatol.xyz", hostedZoneId: "Z067173715955IHMKKU3W" },
  ],
});

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

new OIDCProviderStack(app, "OIDCProviderStack");
