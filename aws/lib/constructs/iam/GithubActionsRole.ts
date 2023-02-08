import {
  CfnOIDCProvider,
  FederatedPrincipal,
  Role,
  RoleProps,
} from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { Domain } from "~/lib/constants";

/**
 * https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect
 */
export interface GithubActionsSubjectClaimsProps {
  repositoryOwner: string;
  repository: string;
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
  provider: CfnOIDCProvider;
  claims: GithubActionsSubjectClaimsProps;
}

export class GithubActionsFederatedPrincipal extends FederatedPrincipal {
  constructor(props: GithubActionsFederatedPrincipalProps) {
    super(
      props.provider.attrArn,
      {
        StringEquals: {
          [`${Domain.GithubActionsToken}:aud`]:
            Domain.GithubActionsOIDCAudience,
        },
        StringLike: {
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

    const claims = actors.map((actor) =>
      props.contexts.map((context) =>
        [
          `repo:${props.repositoryOwner}/${props.repository}`,
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
    );

    return claims.flat();
  }
}

export interface GithubActionsRoleProps extends Omit<RoleProps, "assumedBy"> {
  provider: CfnOIDCProvider;
  claims: GithubActionsSubjectClaimsProps;
}

export class GithubActionsRole extends Role {
  constructor(
    scope: Construct,
    id: string,
    { provider, claims, ...props }: GithubActionsRoleProps,
  ) {
    super(scope, id, {
      ...props,
      assumedBy: new GithubActionsFederatedPrincipal({ provider, claims }),
    });
  }
}
