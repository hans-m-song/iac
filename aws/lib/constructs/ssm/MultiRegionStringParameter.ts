import { Stack } from "aws-cdk-lib";
import {
  ParameterValueType,
  StringParameter,
  StringParameterProps,
} from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Region } from "~/lib/constants";

import { CrossRegionStringParameterCreator } from "./CrossRegionStringParameter";

export interface MultiRegionStringParameterProps extends StringParameterProps {
  regions: Region[];
  parameterName: string;
}

export class MultiRegionStringParameter extends StringParameter {
  constructor(
    scope: Construct,
    id: string,
    { regions, ...props }: MultiRegionStringParameterProps,
  ) {
    super(scope, id, props);

    regions
      .filter((region) => region !== Stack.of(this).region)
      .map(
        (region) =>
          new CrossRegionStringParameterCreator(this, region, {
            region,
            parameterName: props.parameterName,
            parameterType: this.parameterType as ParameterValueType,
            stringValue: props.stringValue,
          }),
      );
  }
}
