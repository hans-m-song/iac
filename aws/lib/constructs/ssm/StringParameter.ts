import * as iam from "aws-cdk-lib/aws-iam";
import * as ssm from "aws-cdk-lib/aws-ssm";
import * as cr from "aws-cdk-lib/custom-resources";
import { Construct } from "constructs";
import { createHash } from "crypto";

import { arn } from "~/lib/utils/arn";

export interface StringParameterCreatorProps {
  region: string;
  parameterName: string;
  stringValue: string;
}

export class StringParameterCreator extends cr.AwsCustomResource {
  constructor(
    scope: Construct,
    id: string,
    props: StringParameterCreatorProps,
  ) {
    const { region, parameterName, stringValue } = props;

    super(scope, id, {
      policy: cr.AwsCustomResourcePolicy.fromStatements([
        new iam.PolicyStatement({
          actions: ["ssm:PutParameter", "ssm:DeleteParameter"],
          resources: [arn(region).ssm.parameter(parameterName)],
        }),
      ]),
      onUpdate: {
        physicalResourceId: cr.PhysicalResourceId.of(
          createHash("sha256")
            .update(id)
            .update(region)
            .update(parameterName)
            .digest("hex"),
        ),
        region,
        service: "SSM",
        action: "putParameter",
        parameters: {
          Name: parameterName,
          Type: ssm.ParameterValueType.STRING,
          Value: stringValue,
          Overwrite: true,
        },
      },
      onDelete: {
        region,
        service: "SSM",
        action: "deleteParameter",
        parameters: {
          Name: parameterName,
        },
      },
    });
  }

  get version() {
    return this.getResponseFieldReference("Version").toString();
  }
}

export interface StringParameterReaderProps {
  region: string;
  parameterName: string;
  withDecryption?: boolean;
}

export class StringParameterReader extends cr.AwsCustomResource {
  constructor(scope: Construct, id: string, props: StringParameterReaderProps) {
    super(scope, id, {
      policy: cr.AwsCustomResourcePolicy.fromStatements([
        new iam.PolicyStatement({
          actions: ["ssm:GetParameter"],
          resources: [arn(props.region).ssm.parameter(props.parameterName)],
        }),
      ]),
      onUpdate: {
        physicalResourceId: cr.PhysicalResourceId.of(Date.now().toString()),
        region: props.region,
        action: "getParameter",
        service: "SSM",
        parameters: {
          Name: props.parameterName,
          WithDecryption: props.withDecryption,
        },
      },
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
    return this.getResponseFieldReference("Parameter.Value").toString();
  }
}
