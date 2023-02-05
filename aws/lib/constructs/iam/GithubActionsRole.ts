import { FederatedPrincipal, Role, RoleProps } from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { Domain } from "~/lib/constants";

const toArray = (input?: string | string[]): string[] => {
  if (!input) {
    return ["*"];
  }

  if (!Array.isArray(input)) {
    return [input];
  }

  return input;
};

/**
 * https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect
 */
export interface GithubActionsSubjectClaimsProps {
  repositoryOwner: string;
  repository: string;
  context: (
    | { environment: string }
    | { branch: string }
    | { pullRequest: true }
  )[];
  workflowName?: string;
  jobWorkflowRef?: string;
  actors?: string[];
}

export interface GithubActionsFederatedPrincipalProps {
  claims: GithubActionsSubjectClaimsProps;
}

export class GithubActionsFederatedPrincipal extends FederatedPrincipal {
  constructor(props: GithubActionsFederatedPrincipalProps) {
    super(
      Domain.GithubActionsToken,
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
      props.context.map((context) =>
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
  claims: GithubActionsSubjectClaimsProps;
}

export class GithubActionsRole extends Role {
  constructor(
    scope: Construct,
    id: string,
    { claims, ...props }: GithubActionsRoleProps,
  ) {
    super(scope, id, {
      ...props,
      assumedBy: new GithubActionsFederatedPrincipal({ claims }),
    });
  }
}
