import "dotenv/config";
import "source-map-support/register";

import * as cdk from "aws-cdk-lib";

import { Stack } from "~/lib/cdk/Stack";
import { ECR, Region, hostedZones } from "~/lib/constants";
import { CertificateStack } from "~/lib/constructs/cloudformation/CertificateStack";
import { CloudflareDNSStack } from "~/lib/constructs/cloudformation/CloudflareDNSStack";
import { DNSStack } from "~/lib/constructs/cloudformation/DNSStack";
import { ECRPublicStack } from "~/lib/constructs/cloudformation/ECRPublicStack";
import { HostedZoneUpdateStack } from "~/lib/constructs/cloudformation/HostedZoneUpdateStack";

const app = new cdk.App();

new CertificateStack(app, "Certificate", {
  env: { region: Region.NVirginia },
  requests: [
    { domainName: "hsong.me" },
    {
      domainName: "cloud.axatol.xyz",
      alternateNames: ["*.cloud.axatol.xyz"],
    },
  ],
});

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
  hostedZones,
  records: {
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

new ECRPublicStack(app, "ECRPublic", {
  env: { region: Region.NVirginia },
  repositories: Object.values(ECR),
});

new HostedZoneUpdateStack(app, "HostedZoneUpdateStack", {
  env: { region: Region.Sydney },
  hostedZones: Object.values(hostedZones),
});

for (const child of app.node.children) {
  (child as Stack).tag();
}
