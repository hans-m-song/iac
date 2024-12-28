import "dotenv/config";
import "source-map-support/register";

import * as cdk from "aws-cdk-lib";

import {
  ECR,
  ECRPublic,
  Region,
  githubPagesRecords,
  hostedZones,
} from "~/lib/constants";
import { CloudflareDNSStack } from "~/lib/constructs/cloudformation/CloudflareDNSStack";
import { DNSStack } from "~/lib/constructs/cloudformation/DNSStack";
import { ECRPrivateStack } from "~/lib/constructs/cloudformation/ECRPrivateStack";
import { ECRPublicStack } from "~/lib/constructs/cloudformation/ECRPublicStack";
import { OIDCDiscoveryStack } from "~/lib/constructs/cloudformation/OIDCDiscoveryStack";

const app = new cdk.App();

new CloudflareDNSStack(app, "CloudflareDNS", {
  env: { region: Region.Sydney },
  records: [
    {
      site: "axatol.xyz",
      name: "home-assistant-integrations.charts.axatol.xyz",
      type: "CNAME",
      value: "hans-m-song.github.io",
    },
    {
      site: "axatol.xyz",
      name: "huisheng.charts.axatol.xyz",
      type: "CNAME",
      value: "hans-m-song.github.io",
    },
  ],
});

new DNSStack(app, "DNS", {
  env: { region: Region.Sydney },
  records: [
    {
      name: "hsong.me.",
      hostedZone: hostedZones.hsong_me,
      ...githubPagesRecords,
    },
  ],
});

new ECRPrivateStack(app, "ECRPrivate", {
  env: { region: Region.Sydney },
  repositories: Object.values(ECR),
});

new ECRPublicStack(app, "ECRPublic", {
  env: { region: Region.NVirginia },
  repositories: Object.values(ECRPublic),
});

new OIDCDiscoveryStack(app, "WheatleyOIDCDiscovery", {
  env: { region: Region.Sydney },
  issuerDomainName: "oidc.wheatley.cloud.axatol.xyz",
  hostedZoneId: hostedZones.cloud_axatol_xyz.hostedZoneId,
  zoneName: hostedZones.cloud_axatol_xyz.zoneName,
});
