import { App, Stack } from "aws-cdk-lib";
import { HostedZoneUpdatePolicy } from "@lib/iam/Policy-Route53-HostedZoneUpdate.js";

const app = new App();
const stack = new Stack(app, "HostedZoneUpdate");
new HostedZoneUpdatePolicy(stack, [
  { name: "HsongMe", id: "Z09233301OJXCBONJC133" },
  { name: "AxatolXyz", id: "Z067173715955IHMKKU3W" },
]);
