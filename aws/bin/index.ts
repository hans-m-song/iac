import "dotenv/config";
import "source-map-support/register";

import * as cdk from "aws-cdk-lib";

import { ECR, Region, githubPagesRecords, hostedZones } from "~/lib/constants";
import { CloudflareDNSStack } from "~/lib/constructs/cloudformation/CloudflareDNSStack";
import { DNSStack } from "~/lib/constructs/cloudformation/DNSStack";
import { ECRPublicStack } from "~/lib/constructs/cloudformation/ECRPublicStack";
import { HostedZoneUpdateStack } from "~/lib/constructs/cloudformation/HostedZoneUpdateStack";
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

new ECRPublicStack(app, "ECRPublic", {
  env: { region: Region.NVirginia },
  repositories: Object.values(ECR),
});

new HostedZoneUpdateStack(app, "HostedZoneUpdateStack", {
  env: { region: Region.Sydney },
  hostedZones: Object.values(hostedZones),
});

new OIDCDiscoveryStack(app, "WheatleyOIDCDiscovery", {
  env: { region: Region.Sydney },
  issuerDomainName: "oidc.wheatley.cloud.axatol.xyz",
  hostedZoneId: hostedZones.cloud_axatol_xyz.hostedZoneId,
  zoneName: hostedZones.cloud_axatol_xyz.zoneName,
});
