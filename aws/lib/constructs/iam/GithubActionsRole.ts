import { FederatedPrincipal, Role, RoleProps } from "aws-cdk-lib/aws-iam";
import { StringParameter } from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Domain, SSM } from "~/lib/constants";

/**
 * https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect
 */
export interface GithubActionsSubjectClaimsProps {
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
  providerArn: string;
  claims: GithubActionsSubjectClaimsProps;
}

export class GithubActionsFederatedPrincipal extends FederatedPrincipal {
  constructor(props: GithubActionsFederatedPrincipalProps) {
    super(
      props.providerArn,
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
          `repo:${props.repository}`,
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
  providerArn?: string;
  claims: GithubActionsSubjectClaimsProps;
}

export class GithubActionsRole extends Role {
  constructor(
    scope: Construct,
    id: string,
    { providerArn, claims, ...props }: GithubActionsRoleProps,
  ) {
    const arn =
      providerArn ??
      StringParameter.valueForStringParameter(
        scope,
        SSM.GithubActionsOIDCProviderARN,
      );

    super(scope, id, {
      ...props,
      assumedBy: new GithubActionsFederatedPrincipal({
        providerArn: arn,
        claims,
      }),
    });
  }
}
