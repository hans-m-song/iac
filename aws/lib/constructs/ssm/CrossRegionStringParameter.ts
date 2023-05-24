import { PolicyStatement } from "aws-cdk-lib/aws-iam";
import { ParameterValueType } from "aws-cdk-lib/aws-ssm";
import {
  AwsCustomResource,
  AwsCustomResourcePolicy,
  PhysicalResourceId,
} from "aws-cdk-lib/custom-resources";
import { Construct } from "constructs";
import { createHash } from "crypto";

import { arn } from "~/lib/utils/arn";

export interface CrossRegionStringParameterCreatorProps {
  region: string;
  parameterName: string;
  parameterType?: ParameterValueType;
  stringValue: string;
}

export class CrossRegionStringParameterCreator extends AwsCustomResource {
  constructor(
    scope: Construct,
    id: string,
    props: CrossRegionStringParameterCreatorProps,
  ) {
    const { region, parameterName, parameterType, stringValue } = {
      parameterType: ParameterValueType.STRING,
      ...props,
    };

    const physicalId = createHash("sha256")
      .update(id)
      .update(parameterType ?? ParameterValueType.STRING)
      .update(stringValue)
      .digest("hex");

    super(scope, id, {
      onUpdate: {
        action: "putParameter",
        service: "SSM",
        parameters: {
          Name: parameterName,
          Type: parameterType,
          Value: stringValue,
          Overwrite: true,
        },
        region: region,
        physicalResourceId: PhysicalResourceId.of(physicalId),
      },
      policy: AwsCustomResourcePolicy.fromStatements([
        new PolicyStatement({
          actions: ["ssm:PutParameter"],
          resources: [arn(region).ssm.parameter(parameterName)],
        }),
      ]),
    });
  }

  get tier() {
    return this.getResponseFieldReference("Tier").toString();
  }

  get version() {
    return this.getResponseFieldReference("Version").toString();
  }
}

export interface CrossRegionStringParameterReaderProps {
  region: string;
  parameterName: string;
  withDecryption?: boolean;
}

export class CrossRegionStringParameterReader extends AwsCustomResource {
  constructor(
    scope: Construct,
    id: string,
    props: CrossRegionStringParameterReaderProps,
  ) {
    super(scope, id, {
      onUpdate: {
        action: "getParameter",
        service: "SSM",
        parameters: {
          Name: props.parameterName,
          WithDecryption: props.withDecryption,
        },
        region: props.region,
        physicalResourceId: PhysicalResourceId.of(Date.now().toString()),
      },
      policy: AwsCustomResourcePolicy.fromStatements([
        new PolicyStatement({
          actions: ["ssm:GetParameter"],
          resources: [arn(props.region).ssm.parameter(props.parameterName)],
        }),
      ]),
    });
  }

  get arn() {
    return this.getResponseFieldReference("Parameter.ARN").toString();
  }

  get type() {
    return this.getResponseFieldReference("Parameter.Type").toString();
  }

  get version() {
    return this.getResponseFieldReference("Parameter.Version").toString();
  }

  get value() {
    return this.getResponseFieldReference("Parameter.Version").toString();
  }
}
