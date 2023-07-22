import * as iam from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { Domain, URI } from "~/lib/constants";
import { arn } from "~/lib/utils/arn";

interface TerraformClaimProps {
  organization: string;
  project: string;
  workspace: string;
  runPhase: string;
}

class TerraformClaim {
  props: TerraformClaimProps;

  constructor(props: TerraformClaimProps) {
    this.props = props;
  }

  static defaults(props: Partial<TerraformClaimProps>) {
    return new TerraformClaim({
      organization: props.organization ?? "axatol",
      project: props.project ?? "default",
      workspace: props.workspace ?? "default",
      runPhase: props.runPhase ?? "*",
    });
  }

  toString() {
    return [
      "organization",
      this.props.organization,
      "project",
      this.props.project,
      "workspace",
      this.props.workspace,
      "run_phase",
      this.props.runPhase,
    ].join(":");
  }
}

export interface TerraformFederatedPrincipalProps {
  providerArn: string;
  claims?: Partial<TerraformClaimProps>[];
}

export class TerraformFederatedPrincipal extends iam.FederatedPrincipal {
  constructor(props: TerraformFederatedPrincipalProps) {
    super(
      props.providerArn,
      {
        "StringEquals": {
          [`${URI.Terraform}:aud`]: Domain.TerraformAudience,
        },
        "ForAnyValue:StringEquals": {
          [`${URI.Terraform}:sub`]: props.claims
            ? props.claims.map((claim) =>
                TerraformClaim.defaults(claim).toString(),
              )
            : [TerraformClaim.defaults({}).toString()],
        },
      },
      "sts:AssumeRoleWithWebIdentity",
    );
  }
}

export interface TerraformRoleProps extends Omit<iam.RoleProps, "assumedBy"> {
  providerArn?: string;
  claims?: Partial<TerraformClaimProps>[];
}

export class TerraformRole extends iam.Role {
  constructor(
    scope: Construct,
    id: string,
    { providerArn, claims, ...props }: TerraformRoleProps,
  ) {
    super(scope, id, {
      ...props,
      assumedBy: new TerraformFederatedPrincipal({
        providerArn: providerArn ?? arn().iam.oidcprovider(Domain.Terraform),
        claims,
      }),
    });
  }

  addPolicies(...statements: iam.PolicyStatementProps[]) {
    statements.forEach((statement) =>
      this.addToPolicy(new iam.PolicyStatement(statement)),
    );
  }
}
