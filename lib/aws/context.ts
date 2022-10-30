import { Construct } from "constructs";

const CONTEXT_KEY_QUALIFIER = "@aws-cdk/core:bootstrapQualifier";

const assertContext = (scope: Construct, key: string) => {
  const value = scope.node.tryGetContext(key);
  if (typeof value !== "string") {
    throw new Error(`no value for context key: ${key}`);
  }

  return value;
};

export const getContext = (scope: Construct) => {
  const cwd = process.cwd();
  const qualifier = assertContext(scope, CONTEXT_KEY_QUALIFIER);
  return { cwd, qualifier };
};
