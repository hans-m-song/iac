import { Fn } from "aws-cdk-lib";

export const arn = (region?: string, account?: string) => {
  const distribution = (distributionId: string) =>
    [
      "arn",
      Fn.ref("AWS::Partition"),
      "cloudfront",
      "",
      account ?? Fn.ref("AWS::AccountId"),
      `distribution/${distributionId}`,
    ].join(":");

  const hostedzone = (hostedZoneId: string) =>
    [
      "arn",
      Fn.ref("AWS::Partition"),
      "route53",
      "",
      "",
      `hostedzone/${hostedZoneId}`,
    ].join(":");

  const loggroup = (name: string) =>
    [
      "arn",
      Fn.ref("AWS::Partition"),
      "logs",
      region ?? Fn.ref("AWS::Region"),
      account ?? Fn.ref("AWS::AccountId"),
      "log-group",
      name,
    ].join(":");

  const logstream = (logGroupName: string, name: string) =>
    [loggroup(logGroupName), "log-stream", name].join(":");

  const oidcprovider = (authority: string) =>
    [
      "arn",
      Fn.ref("AWS::Partition"),
      "iam",
      "",
      account ?? Fn.ref("AWS::AccountId"),
      `oidc-provider/${authority}`,
    ].join(":");

  const parameter = (parameterName: string) =>
    [
      "arn",
      Fn.ref("AWS::Partition"),
      "ssm",
      region ?? Fn.ref("AWS::Region"),
      account ?? Fn.ref("AWS::AccountId"),
      `parameter${
        parameterName.startsWith("/") ? parameterName : `/${parameterName}`
      }`,
    ].join(":");

  const repository =
    (service: "ecr" | "ecr-public") => (repositoryName: string) =>
      [
        "arn",
        Fn.ref("AWS::Partition"),
        service,
        service === "ecr-public" ? "" : region ?? Fn.ref("AWS::Region"),
        account ?? Fn.ref("AWS::AccountId"),
        `repository/${repositoryName}`,
      ].join(":");

  return {
    cf: {
      distribution,
    },
    cw: {
      loggroup,
      logstream,
    },
    ecr: {
      repository: repository("ecr"),
    },
    ecrp: {
      repository: repository("ecr-public"),
    },
    iam: {
      oidcprovider,
    },
    r53: {
      hostedzone,
    },
    ssm: {
      parameter,
    },
  };
};
