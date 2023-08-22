import * as cdk from "aws-cdk-lib";
import * as ddb from "aws-cdk-lib/aws-dynamodb";
import * as iam from "aws-cdk-lib/aws-iam";
import * as s3 from "aws-cdk-lib/aws-s3";
import * as ssm from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";
import { SSM } from "~/lib/constants";
import { TerraformOIDCProvider } from "~/lib/constructs/iam/TerraformOIDCProvider";
import { TerraformRole } from "~/lib/constructs/iam/TerraformRole";
import { arn } from "~/lib/utils/arn";

export class TerraformBackendStack extends Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    const provider = new TerraformOIDCProvider(this, "TerraformOIDCProvider");

    const planRole = new TerraformRole(this, "PlanRole", {
      providerArn: provider.attrArn,
    });

    stateBucket.grantRead(planRole);
    lockTable.grantReadWriteData(planRole);

    planRole.addPolicies({
      actions: ["ssm:GetParameter"],
      effect: iam.Effect.ALLOW,
      resources: [
        arn().ssm.parameter("/cdk-boostrap/*"),
        arn().ssm.parameter("/infrastructure/acm/*"),
        arn().ssm.parameter("/infrastructure/iam/*"),
        arn().ssm.parameter("/infrastructure/new_relic/*"),
      ],
    });

    this.output("PlanRoleARN", lockTable.tableName);

    new ssm.StringParameter(this, "PlanRoleARNParameter", {
      parameterName: SSM.TerraformPlanRoleARN,
      stringValue: planRole.roleArn,
    });

    const applyRole = new TerraformRole(this, "ApplyRole", {
      providerArn: provider.attrArn,
    });

    stateBucket.grantReadWrite(applyRole);
    lockTable.grantReadWriteData(applyRole);

    applyRole.addPolicies({
      actions: ["ssm:GetParameter", "ssm:PutParameter"],
      effect: iam.Effect.ALLOW,
      resources: [
        arn().ssm.parameter("/cdk-boostrap/*"),
        arn().ssm.parameter("/infrastructure/acm/*"),
        arn().ssm.parameter("/infrastructure/iam/*"),
        arn().ssm.parameter("/infrastructure/new_relic/*"),
      ],
    });

    this.output("ApplyRoleARN", lockTable.tableName);

    new ssm.StringParameter(this, "ApplyRoleARNParameter", {
      parameterName: SSM.TerraformApplyRoleARN,
      stringValue: applyRole.roleArn,
    });
  }
}
