import * as iam from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

import { Stack, StackProps } from "~/lib/cdk/Stack";
import { SSM } from "~/lib/constants";
import { StringParameterReader } from "~/lib/constructs/ssm/StringParameter";

const NEW_RELIC_AWS_ACCOUNT_ID = "754728514883";

export class NewRelicIntegrationStack extends Stack {
  role: iam.IRole;

  constructor(scope: Construct, id: string, props: StackProps) {
    super(scope, id, props);

    const accountID = new StringParameterReader(
      this,
      "NewRelicAccountIDParameter",
      {
        parameterName: SSM.NewRelicAccountID,
        region: this.region,
        withDecryption: true,
      },
    );

    this.role = new iam.Role(this, "NewRelicRole", {
      roleName: "NewRelicInfrastructure-Integrations",
      assumedBy: new iam.PrincipalWithConditions(
        new iam.AccountPrincipal(NEW_RELIC_AWS_ACCOUNT_ID),
        { StringEquals: { "sts:ExternalId": accountID.value } },
      ),
      managedPolicies: [
        iam.ManagedPolicy.fromAwsManagedPolicyName("ReadOnlyAccess"),
      ],
      inlinePolicies: {
        ViewBudgetsPolicy: new iam.PolicyDocument({
          statements: [
            new iam.PolicyStatement({
              effect: iam.Effect.ALLOW,
              actions: ["budgets:ViewBudget"],
              resources: ["*"],
            }),
          ],
        }),
      },
    });

    this.output("RoleARN", this.role.roleArn);
  }
}
