import { StackProps } from "aws-cdk-lib";
import { ARecord, HostedZone, RecordTarget } from "aws-cdk-lib/aws-route53";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { hostedZones } from "~/lib/constants";
import { Instance } from "~/lib/constructs/lightsail/Instance";

export class XRayAgentStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const instance = new Instance(this, "Instance", {
      instanceName: "xray-agent",
    });

    this.output("PublicIP", instance.publicIpAddress.toString());

    const zone = HostedZone.fromHostedZoneAttributes(
      this,
      "HostedZone",
      hostedZones.hsong_me,
    );

    new ARecord(this, "ARecord", {
      zone,
      recordName: "stargate",
      target: RecordTarget.fromIpAddresses(instance.publicIpAddress.toString()),
    });
  }
}

// const instance = new lsl.CfnInstance(this, "Instance", {
//   blueprintId: "ubuntu_22_04",
//   bundleId: "micro_2_0",
//   instanceName: "xray-agent",
//   availabilityZone: "ap-southeast-1a",
//   userData: [
//     "sudo apt-get update",
//     "sudo apt-get upgrade -y",
//     "sudo apt-get install -y --no-install-recommends",
//     [
//       "binutils",
//       "ca-certificates",
//       "crontabs",
//       "curl",
//       "dig",
//       "jq",
//       "lsb-release",
//       "lsof",
//       "ping6",
//       "qrencode",
//       "socat",
//       "socat",
//       "sudo",
//       "unzip",
//       "wget",
//     ].join(" "),
//     "curl -L "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" > install.sh",
//     "chmod +x ./install.sh",
//   ].join(" && "),
// });
