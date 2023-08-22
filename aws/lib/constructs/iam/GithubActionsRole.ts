import {
  FederatedPrincipal,
  PolicyStatement,
  PolicyStatementProps,
  Role,
  RoleProps,
} from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { Domain } from "~/lib/constants";
import { arn } from "~/lib/utils/arn";

/**
 * https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect
 */
export interface GithubActionsSubjectClaims {
  repo: string;
  context: {
    env?: string;
    ref?: string;
    pr?: boolean;
  };
  workflowRef?: string;
  actor?: string;
}

export interface GithubActionsFederatedPrincipalProps {
  providerArn: string;
  claims: GithubActionsSubjectClaims[];
}

export class GithubActionsFederatedPrincipal extends FederatedPrincipal {
  constructor(props: GithubActionsFederatedPrincipalProps) {
    super(
      props.providerArn,
      {
        "StringEquals": {
          [`${Domain.GithubActionsToken}:aud`]: Domain.AWSSecurityTokenService,
        },
        "ForAnyValue:StringLike": {
          [`${Domain.GithubActionsToken}:sub`]: props.claims.flatMap(
            GithubActionsFederatedPrincipal.formatClaims,
          ),
        },
      },
      "sts:AssumeRoleWithWebIdentity",
    );
  }

  private static formatClaims(claims: GithubActionsSubjectClaims): string[] {
    const contexts = [];
    const { env, ref, pr } = claims.context;

    if (pr) {
      contexts.push("pull_request");
    }

    if (ref) {
      contexts.push(`ref:refs/heads/${ref}`);
    }

    if (env) {
      contexts.push(`environment:${env}`);
    }

    return contexts.map((context) =>
      [
        `repo:${claims.repo}`,
        context,
        `job_workflow_ref:${claims.workflowRef ?? "*"}`,
        `actor:${claims.actor ?? "*"}`,
      ].join(":"),
    );
  }
}

export interface GithubActionsRoleProps extends Omit<RoleProps, "assumedBy"> {
  claims: GithubActionsSubjectClaims[];
}

export class GithubActionsRole extends Role {
  constructor(
    scope: Construct,
    id: string,
    { claims, ...props }: GithubActionsRoleProps,
  ) {
    super(scope, id, {
      ...props,
      assumedBy: new GithubActionsFederatedPrincipal({
        providerArn: arn().iam.oidcprovider(Domain.GithubActionsToken),
        claims,
      }),
    });
  }

  addClaim(...claims: GithubActionsSubjectClaims[]) {
    this.grantAssumeRole(
      new GithubActionsFederatedPrincipal({
        providerArn: arn().iam.oidcprovider(Domain.GithubActionsToken),
        claims,
      }),
    );
  }

  addPolicies(...statements: PolicyStatementProps[]) {
    statements.forEach((statement) =>
      this.addToPolicy(new PolicyStatement(statement)),
    );
  }
}
