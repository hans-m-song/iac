data "aws_iam_policy_document" "lambda_permissions_boundary" {
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
      "arn:aws:ssm:*:${local.account_id}:parameter/infrastructure/acm/*/certificate_arn",
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
  name     = "/application/shared/lambda_permissions_boundary_arn"
  type     = "String"
  value    = aws_iam_policy.lambda_permissions_boundary.arn
}

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
}

resource "aws_iam_policy" "custom_resource_permissions_boundary" {
  provider = aws.apse2
  name     = "custom-resource-permissions-boundary"
  policy   = data.aws_iam_policy_document.custom_resource_permissions_boundary.json
}

resource "aws_ssm_parameter" "custom_resource_permissions_boundary" {
  provider = aws.apse2
  name     = "/application/shared/custom_resource_permissions_boundary_arn"
  type     = "String"
  value    = aws_iam_policy.custom_resource_permissions_boundary.arn
}
