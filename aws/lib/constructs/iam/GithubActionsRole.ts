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
  owner: string;
  repo: string;
  file?: string;
  reference?: string;
  environments?: string | string[];
  actors?: string | string[];
  events?: string | string[];
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
    const file = props.file ?? "*";
    const reference = props.reference ?? "*";
    const events = toArray(props.events);
    const environments = toArray(props.environments);
    const actors = toArray(props.actors);

    const claims = events
      .map((event) =>
        environments.map((environment) =>
          actors.map((actor) => ({
            job_workflow_ref: `${props.owner}/${props.repo}/${file}@${reference}`,
            event_name: event,
            actor: actor,
            environment: environment,
          })),
        ),
      )
      .flat(2);

    return claims.map((claim) =>
      Object.entries(claim)
        .map((pair) => pair.join(":"))
        .join(":"),
    );
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
