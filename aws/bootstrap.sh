#!/bin/bash

set -eux -o pipefail

QUALIFIER=toolkit
FILE_ASSETS_BUCKET_KMS_KEY_ID=AWS_MANAGED_KEY
STACK_NAME=CDKToolkit
GIT_REPOSITORY=https://github.com/hans-m-song/iac
PURPOSE=Infrastructure

aws cloudformation deploy \
  --region ap-southeast-2 \
  --template-file ./CDKToolkit.yaml \
  --stack-name CDKToolkit \
  --parameter-overrides \
  Qualifier=$QUALIFIER \
  FileAssetsBucketKmsKeyId=$FILE_ASSETS_BUCKET_KMS_KEY_ID \
  --capabilities CAPABILITY_NAMED_IAM \
  --tags \
  StackName=$STACK_NAME \
  GitRepository=$GIT_REPOSITORY \
  Purpose=$PURPOSE

aws cloudformation deploy \
  --region us-east-1 \
  --template-file ./CDKToolkit.yaml \
  --stack-name CDKToolkit \
  --parameter-overrides \
  Qualifier=$QUALIFIER \
  FileAssetsBucketKmsKeyId=$FILE_ASSETS_BUCKET_KMS_KEY_ID \
  --capabilities CAPABILITY_NAMED_IAM \
  --tags \
  StackName=$STACK_NAME \
  GitRepository=$GIT_REPOSITORY \
  Purpose=$PURPOSE

aws cloudformation deploy \
  --region ap-southeast-1 \
  --template-file ./CDKToolkit.yaml \
  --stack-name CDKToolkit \
  --parameter-overrides \
  Qualifier=$QUALIFIER \
  FileAssetsBucketKmsKeyId=$FILE_ASSETS_BUCKET_KMS_KEY_ID \
  --capabilities CAPABILITY_NAMED_IAM \
  --tags \
  StackName=$STACK_NAME \
  GitRepository=$GIT_REPOSITORY \
  Purpose=$PURPOSE
