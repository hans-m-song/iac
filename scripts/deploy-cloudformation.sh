#!/bin/bash
set -eo pipefail

if [ -z "$1" ]; then
  echo "Usage: $0 <template_filepath>"
  exit 1
fi

account=$(aws sts get-caller-identity --query Account --output text)
region=${AWS_REGION:-ap-southeast-2}
filepath=$1
name=$(basename -s .yaml $filepath)
profile=${AWS_PROFILE:-default}
exec_role_arn=arn:aws:iam::${account}:role/cdk-toolkit-cfn-exec-role-${account}-${region}

echo "filepath: $filepath"
echo "name:     $name"
echo "account:  $account"
echo "region:   $region"
echo "profile:  $profile"
echo "role arn: $exec_role_arn"

echo "--- creating changeset ---"
change_set_id=$(
  aws cloudformation create-change-set \
    --profile $profile \
    --region $region \
    --role-arn arn:aws:iam::${account}:role/cdk-toolkit-cfn-exec-role-${account}-${region} \
    --stack-name $name \
    --change-set-name $name-$(date +%s) \
    --template-body file://$filepath \
    --capabilities CAPABILITY_NAMED_IAM \
    --query Id \
    --output text
)

echo "--- waiting for changeset to be created ---"
aws cloudformation wait change-set-create-complete \
  --profile $profile \
  --region $region \
  --change-set-name $change_set_id

aws cloudformation describe-change-set \
  --profile $profile \
  --region $region \
  --change-set-name $change_set_id

echo "continue? (y/N)"
read -r continue
continue=${continue:-n}

if [ "$continue" != "y" ]; then
  echo "aborting"
  exit 1
fi

echo "--- executing changeset ---"
aws cloudformation execute-change-set \
  --profile $profile \
  --region $region \
  --change-set-name $change_set_id

echo "--- waiting for stack update to complete ---"
aws cloudformation wait stack-update-complete \
  --profile $profile \
  --region $region \
  --stack-name $name
