data "aws_iam_policy_document" "custom_resource_permissions_boundary" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:PutLogEvents",
      "xray:Put*",
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]
    resources = [
      "arn:aws:ssm:*:${local.account_id}:parameter/application/*/dev/*",
      "arn:aws:ssm:*:${local.account_id}:parameter/application/*/prd/*",
      "arn:aws:ssm:*:${local.account_id}:parameter/application/shared/*",
      "arn:aws:ssm:*:${local.account_id}:parameter/cdk-bootstrap/toolkit/*",
      "arn:aws:ssm:*:${local.account_id}:parameter/custom_resource/acm/*/certificate_arn",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutBucketNotification"
    ]
    resources = [
      "arn:aws:s3:::bucket/*",
    ]
  }
}

resource "aws_iam_policy" "custom_resource_permissions_boundary" {
  provider = aws.apse2
  name     = "custom-resource-permissions-boundary"
  policy   = data.aws_iam_policy_document.custom_resource_permissions_boundary.json
}

resource "aws_ssm_parameter" "custom_resource_permissions_boundary" {
  provider = aws.apse2
  name     = "/infrastructure/iam/custom_resource_permissions_boundary_arn"
  type     = "String"
  value    = aws_iam_policy.custom_resource_permissions_boundary.arn
}

data "aws_iam_policy_document" "deployment_permissions_boundary" {
  statement {
    effect = "Allow"
    actions = [
      "cloudformation:*",
      "cloudfront:*",
      "cloudwatch:*",
      "iam:*",
      "ssm:*",
    ]
    resources = ["*"]
  }

  statement {
    effect  = "Deny"
    actions = ["*"]
    resources = [
      "arn:aws:iam::${local.account_id}:user/*"
    ]
  }
}

resource "aws_iam_policy" "deployment_permissions_boundary" {
  provider = aws.apse2
  name     = "deployment-permissions-boundary"
  policy   = data.aws_iam_policy_document.deployment_permissions_boundary.json
}

resource "aws_ssm_parameter" "deployment_permissions_boundary" {
  provider = aws.apse2
  name     = "/infrastructure/iam/deployment_permissions_boundary_arn"
  type     = "String"
  value    = aws_iam_policy.deployment_permissions_boundary.arn
}

data "aws_iam_policy_document" "lambda_permissions_boundary" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:PutLogEvents",
      "xray:Put*",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]
    resources = [
      "arn:aws:ssm:*:${local.account_id}:parameter/application/*/dev/*",
      "arn:aws:ssm:*:${local.account_id}:parameter/application/*/prd/*",
      "arn:aws:ssm:*:${local.account_id}:parameter/application/shared/*",
      "arn:aws:ssm:*:${local.account_id}:parameter/cdk-bootstrap/toolkit/*",
      "arn:aws:ssm:*:${local.account_id}:parameter/infrastructure/acm/*/certificate_arn",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectAttributes",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionAttributes",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    not_resources = [
      "arn:aws:s3:::aws-cloudtrail-logs-${local.account_id}-*",
      "arn:aws:s3:::aws-cloudtrail-logs-${local.account_id}-*/*",
      "arn:aws:s3:::backup-${local.account_id}",
      "arn:aws:s3:::backup-${local.account_id}/*",
      "arn:aws:s3:::cdk-*-assets-${local.account_id}-*",
      "arn:aws:s3:::cdk-*-assets-${local.account_id}-*/*",
      "arn:aws:s3:::cf-templates-*",
      "arn:aws:s3:::cf-templates-*/*",
      "arn:aws:s3:::terraform-state-${local.account_id}",
      "arn:aws:s3:::terraform-state-${local.account_id}/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:DeleteItem",
      "dynamodb:DescribeStream",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:PartiQLDelete",
      "dynamodb:PartiQLInsert",
      "dynamodb:PartiQLSelect",
      "dynamodb:PartiQLUpdate",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
    ]
    not_resources = [
      "arn:aws:dynamodb:ap-southeast-2:${local.account_id}:table/terraform-state-lock"
    ]
  }
}

resource "aws_iam_policy" "lambda_permissions_boundary" {
  provider = aws.apse2
  name     = "lambda-permissions-boundary"
  policy   = data.aws_iam_policy_document.lambda_permissions_boundary.json
}

resource "aws_ssm_parameter" "lambda_permissions_boundary" {
  provider = aws.apse2
  name     = "/infrastructure/iam/lambda_permissions_boundary_arn"
  type     = "String"
  value    = aws_iam_policy.lambda_permissions_boundary.arn
}
