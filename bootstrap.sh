#!/bin/bash

set -eux -o pipefail

aws cloudformation deploy
--region ap-southeast-2 \
  --template-file ./CDKToolkit.yaml \
  --stack-name CDKToolkit \
  --parameter-overrides Qualifier=toolkit FileAssetsBucketKmsKeyId=AWS_MANAGED_KEY \
  --capabilities CAPABILITY_NAMED_IAM \
  --tags Stack=CDKToolkit

aws cloudformation deploy \
  --region us-east-1 \
  --template-file ./CDKToolkit.yaml \
  --stack-name CDKToolkit \
  --parameter-overrides Qualifier=toolkit FileAssetsBucketKmsKeyId=AWS_MANAGED_KEY \
  --capabilities CAPABILITY_NAMED_IAM \
  --tags Stack=CDKToolkit
