import { Arn, ArnFormat, Stack } from "aws-cdk-lib";
import { Construct } from "constructs";

import { Region } from "~/lib/constants";

export const arn = (
  scope: Construct | null,
  region?: string,
  account?: string,
) => {
  const stack = scope ? Stack.of(scope) : undefined;

  return {
    parameter: (path: string) =>
      Arn.format(
        {
          service: "ssm",
          region: region ?? stack?.region ?? Region.APSE2,
          account: account ?? stack?.account,
          resource: "parameter",
          resourceName: path,
          arnFormat: ArnFormat.SLASH_RESOURCE_NAME,
        },
        stack,
      ),

    hostedzone: (id: string) =>
      Arn.format(
        {
          service: "route53",
          region: "",
          account: "",
          resource: "hostedzone",
          resourceName: id,
          arnFormat: ArnFormat.SLASH_RESOURCE_NAME,
        },
        stack,
      ),
  };
};
