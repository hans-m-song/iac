import "dotenv/config";
import "source-map-support/register";

import { App } from "aws-cdk-lib";

import { ECR, hostedZones } from "~/lib/constants";

import { AWSServiceRoleStack } from "./AWSServiceRoleStack";
import { BoundaryPolicyStack } from "./BoundaryPolicyStack";
import { CertificateStack } from "./CertificateStack";
import { GithubActionsOIDCProviderStack } from "./GithubActionsOIDCProviderStack";
import { HostedZoneUpdateStack } from "./HostedZoneUpdateStack";
import { ManagedECRPublicStack } from "./ManagedECRPublicStack";

const app = new App();

new AWSServiceRoleStack(app, "AWSServiceRoleStack");

new BoundaryPolicyStack(app, "BoundaryPolicyStack");

new CertificateStack(app, "CertificateStack-USE1", {
  env: { region: "us-east-1" },
  domainNames: ["blog.hsong.me"],
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
