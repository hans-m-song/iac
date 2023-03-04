import { Construct } from "constructs";

import packageJson from "~/package.json";

import { Stack } from "./Stack";

const CONTEXT_KEY_QUALIFIER = "@aws-cdk/core:bootstrapQualifier";

const assertContext = (scope: Construct, key: string) => {
  const value = scope.node.tryGetContext(key);
  if (typeof value !== "string") {
    throw new Error(`no value for context key: ${key}`);
  }

  return value;
};

const tryGetStack = (scope: Construct) => {
  try {
    return Stack.of(scope);
  } catch {
    return null;
  }
};

export const getContext = (scope: Construct) => {
  const cwd = process.cwd();
  const stack = tryGetStack(scope);
  const qualifier = assertContext(scope, CONTEXT_KEY_QUALIFIER);

  const bootstrapName = (purpose: string) => {
    if (!stack) {
      throw new Error("must be called within the scope of a stack");
    }

    return `cdk-${qualifier}-${purpose}-${stack.account}-*`;
  };

  const bootstrapRoleARN = (purpose: string) => {
    const name = bootstrapName(purpose);

    return `arn:aws:iam::${stack?.account}:role/${name}`;
  };

  return {
    repositoryUrl: packageJson.repository.url,
    cwd,
    qualifier,
    bootstrapName,
    bootstrapRoleARN,
  };
};
