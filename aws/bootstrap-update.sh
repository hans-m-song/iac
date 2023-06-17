#!/bin/bash

set -euo pipefail

# Check if the correct number of arguments are provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <region>"
  exit 1
fi

# Set variables from arguments
REGION=$1

STACK=$(
  aws cloudformation describe-stacks \
    --stack-name CDKToolkit \
    --region $REGION \
    --query 'Stacks[0]'
)

# Fetch current parameters and create a parameters file
STACK_ARN=$(echo "$STACK" | jq -rcM '.StackId')
STACK_PARAMETERS=$(echo "$STACK" | jq -rcM '[.Parameters[] | {ParameterKey: .ParameterKey, UsePreviousValue: true}]')

# Create a Change Set and store the change set ARN
CHANGE_SET_ARN=$(
  aws cloudformation create-change-set \
    --stack-name CDKToolkit \
    --region $REGION \
    --template-body file://CDKToolkit.yaml \
    --parameters "$STACK_PARAMETERS" \
    --capabilities CAPABILITY_NAMED_IAM \
    --change-set-name aws-cli-change-set-$(date +"%Y-%m-%d-%H-%M-%S") \
    --query 'Id' \
    --output text
)

# Wait for Change Set creation
aws cloudformation wait change-set-create-complete \
  --change-set-name $CHANGE_SET_ARN \
  --region $REGION

echo "change set: https://$REGION.console.aws.amazon.com/cloudformation/home?region=$REGION#/stacks/changesets/changes?stackId=$STACK_ARN&changeSetId=$CHANGE_SET_ARN"

# Ask the user if they want to execute the Change Set
read -p "Do you want to execute the Change Set? (yes/no): " RESPONSE
if [ "$RESPONSE" != "yes" ]; then
  echo "The Change Set was not executed."
  exit 0
fi

# Execute the Change Set
aws cloudformation execute-change-set \
  --change-set-name $CHANGE_SET_ARN \
  --region $REGION

aws cloudformation wait stack-update-complete \
  --stack-name $STACK_ARN \
  --region $REGION

echo "stack: https://$REGION.console.aws.amazon.com/cloudformation/home?region=$REGION#/stacks/stackinfo?stackId=$STACK_ARN"
