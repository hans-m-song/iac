import { Stack } from "aws-cdk-lib";
import { Construct } from "constructs";

export const arn = (
  scope: Construct | null,
  region?: string,
  account?: string,
) => {
  const stack = scope ? Stack.of(scope) : undefined;

  return {
    hostedzone: (hostedZoneId: string) =>
      [
        "arn",
        stack?.partition ?? "aws",
        "route53",
        "",
        "",
        `hostedzone/${hostedZoneId}`,
      ].join(":"),

    oidcprovider: (authority: string) =>
      [
        "arn",
        stack?.partition ?? "aws",
        "iam",
        "",
        account ?? stack?.account,
        `oidc-provider/${authority}`,
      ].join(":"),

    parameter: (parameterName: string) =>
      [
        "arn",
        stack?.partition ?? "aws",
        "ssm",
        region ?? stack?.region ?? "ap-southeast-2",
        account ?? stack?.account,
        `parameter/${parameterName}`,
      ].join(":"),

    repository: (service: "ecr" | "ecr-public", repositoryName: string) =>
      [
        "arn",
        stack?.partition ?? "aws",
        service,
        service === "ecr-public" ? "" : region ?? stack?.region,
        account ?? stack?.account,
        `repository/${repositoryName}`,
      ].join(":"),
  };
};
