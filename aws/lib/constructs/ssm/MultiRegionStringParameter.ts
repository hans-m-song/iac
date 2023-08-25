import { Stack } from "aws-cdk-lib";
import * as ssm from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Region } from "~/lib/constants";

import { StringParameterCreator } from "./StringParameter";

export interface MultiRegionStringParameterProps {
  regions: Region[];
  parameterName: string;
  stringValue: string;
}

export class MultiRegionStringParameter extends Construct {
  currentRegion?: ssm.IStringParameter;
  otherRegions: StringParameterCreator[];

  constructor(
    scope: Construct,
    id: string,
    { regions, ...props }: MultiRegionStringParameterProps,
  ) {
    super(scope, id);

    const currentRegion = Stack.of(this).region as Region;
    if (regions.includes(currentRegion)) {
      this.currentRegion = new ssm.StringParameter(this, currentRegion, {
        parameterName: props.parameterName,
        stringValue: props.stringValue,
      });
    }

    this.otherRegions = regions
      .filter((region) => region !== currentRegion)
      .map((region) => {
        const parameter = new StringParameterCreator(this, region, {
          region,
          parameterName: props.parameterName,
          stringValue: props.stringValue,
        });

        if (this.currentRegion) {
          parameter.node.addDependency(this.currentRegion);
        }

        return parameter;
      });
  }
}
