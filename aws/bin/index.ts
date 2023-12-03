import "dotenv/config";
import "source-map-support/register";

import * as cdk from "aws-cdk-lib";

import { Stack } from "~/lib/cdk/Stack";
import { ECR, Region, hostedZones } from "~/lib/constants";

import { AWSServiceRoleStack } from "./AWSServiceRoleStack";
import { BoundaryPolicyStack } from "./BoundaryPolicyStack";
import { CertificateStack } from "./CertificateStack";
import { DNSStack } from "./DNSStack";
import { GithubActionsOIDCProviderStack } from "./GithubActionsOIDCProviderStack";
import { HostedZoneUpdateStack } from "./HostedZoneUpdateStack";
import { ManagedECRPublicStack } from "./ManagedECRPublicStack";
import { ManagedPolicyStack } from "./ManagedPolicyStack";
import { NewRelicIntegrationStack } from "./NewRelicIntegrationStack";
import { TerraformBackendStack } from "./TerraformBackendStack";

const app = new cdk.App();

new AWSServiceRoleStack(app, "AWSServiceRoleStack", {
  env: { region: Region.Sydney },
});

new ManagedPolicyStack(app, "ManagedPolicyStack", {
  env: { region: Region.Sydney },
});

new BoundaryPolicyStack(app, "BoundaryPolicyStack", {
  env: { region: Region.Sydney },
});

new CertificateStack(app, "CertificateStack", {
  env: { region: Region.NVirginia },
  requests: [
    { domainName: "hsong.me" },
    {
      domainName: "axatol.xyz",
      alternateNames: ["*.axatol.xyz", "*.oidc.axatol.xyz"],
    },
  ],
});

new DNSStack(app, "DNSStack", {
  env: { region: Region.Sydney },
  hostedZones,
  records: {
    "huisheng.charts.axatol.xyz.": {
      cname: "hans-m-song.github.io",
    },
    "hsong.me.": {
      a: [
        "185.199.108.153",
        "185.199.109.153",
        "185.199.110.153",
        "185.199.111.153",
      ],
      aaaa: [
        "2606:50c0:8000::153",
        "2606:50c0:8001::153",
        "2606:50c0:8002::153",
        "2606:50c0:8003::153",
      ],
    },
  },
});

new GithubActionsOIDCProviderStack(app, "GithubActionsOIDCProviderStack", {
  env: { region: Region.Sydney },
});

new HostedZoneUpdateStack(app, "HostedZoneUpdateStack", {
  env: { region: Region.Sydney },
  hostedZones: Object.values(hostedZones),
});

new ManagedECRPublicStack(app, "ManagedECRPublicStack", {
  env: { region: Region.NVirginia },
  repositories: Object.values(ECR),
});

new TerraformBackendStack(app, "TerraformBackendStack", {
  env: { region: Region.Sydney },
});

new NewRelicIntegrationStack(app, "NewRelicIntegrationStack", {
  env: { region: Region.Sydney },
});

for (const child of app.node.children) {
  (child as Stack).tag();
}
