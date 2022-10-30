#!/bin/bash

set -eux -o pipefail

aws cloudformation deploy \
  --template-file ./resources/cloudformation/CDKToolkit.yaml \
  --stack-name CDKToolkit \
  --parameter-overrides \
  Qualifier=toolkit \
  FileAssetsBucketKmsKeyId=AWS_MANAGED_KEY \
  --capabilities CAPABILITY_NAMED_IAM \
  --tags Stack=CDKToolkit
