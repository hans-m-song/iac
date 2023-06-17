import { Fn } from "aws-cdk-lib";
import { PolicyStatement } from "aws-cdk-lib/aws-iam";
import {
  AwsCustomResource,
  AwsCustomResourcePolicy,
  PhysicalResourceId,
} from "aws-cdk-lib/custom-resources";
import { Construct } from "constructs";

export interface InstanceProps {
  instanceName: string;
  region?: string;
  forceUpdate?: boolean;
}

export class Instance extends AwsCustomResource {
  constructor(scope: Construct, id: string, props: InstanceProps) {
    const { instanceName, region, forceUpdate } = props;

    const physicalId = forceUpdate ? `${Date.now()}` : instanceName;

    super(scope, id, {
      onUpdate: {
        action: "getInstance",
        service: "Lightsail",
        parameters: { instanceName },
        region: region ?? Fn.ref("AWS::Region"),
        physicalResourceId: PhysicalResourceId.of(physicalId),
      },
      policy: AwsCustomResourcePolicy.fromStatements([
        new PolicyStatement({
          actions: ["lightsail:GetInstance"],
          resources: ["*"],
        }),
      ]),
    });
  }

  get arn() {
    return this.getResponseFieldReference("instance.arn");
  }

  get publicIpAddress() {
    return this.getResponseFieldReference("instance.publicIpAddress");
  }
}

// arn:aws:lightsail:ap-southeast-1:255851393769:Instance/9e7e991f-cc43-43cd-9bf9-2922ea074c4f
// xray-agent
