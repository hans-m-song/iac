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
export interface GithubActionsSubjectClaimsProps {
  repositories: string[];
  contexts: (
    | { environment: string }
    | { branch: string }
    | { pullRequest: true }
  )[];
  workflowName?: string;
  jobWorkflowRef?: string;
  actors?: string[];
}

export interface GithubActionsFederatedPrincipalProps {
  providerArn: string;
  claims: GithubActionsSubjectClaimsProps;
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
          [`${Domain.GithubActionsToken}:sub`]:
            GithubActionsFederatedPrincipal.formatClaims(props.claims),
        },
      },
      "sts:AssumeRoleWithWebIdentity",
    );
  }

  private static formatClaims(
    props: GithubActionsSubjectClaimsProps,
  ): string[] {
    const actors = !props.actors ? ["*"] : props.actors;

    const claims = props.repositories.map((repository) =>
      actors.map((actor) =>
        props.contexts.map((context) =>
          [
            `repo:${repository}`,
            "environment" in context && `environment:${context.environment}`,
            "branch" in context && `ref:refs/heads/${context.branch}`,
            "pullRequest" in context && "pull_request",
            `workflow:${props.workflowName ?? "*"}`,
            `job_workflow_ref:${props.jobWorkflowRef ?? "*"}`,
            `actor:${actor}`,
          ]
            .filter(Boolean)
            .join(":"),
        ),
      ),
    );

    return claims.flat(2);
  }
}

export interface GithubActionsRoleProps extends Omit<RoleProps, "assumedBy"> {
  providerArn?: string;
  claims: GithubActionsSubjectClaimsProps;
}

export class GithubActionsRole extends Role {
  constructor(
    scope: Construct,
    id: string,
    { providerArn, claims, ...props }: GithubActionsRoleProps,
  ) {
    super(scope, id, {
      ...props,
      assumedBy: new GithubActionsFederatedPrincipal({
        providerArn:
          providerArn ?? arn().iam.oidcprovider(Domain.GithubActionsToken),
        claims,
      }),
    });
  }

  addPolicies(...statements: PolicyStatementProps[]) {
    statements.forEach((statement) =>
      this.addToPolicy(new PolicyStatement(statement)),
    );
  }
}
