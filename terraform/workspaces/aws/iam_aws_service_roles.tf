data "aws_iam_policy_document" "cloudtrail_logging_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_logging_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:*:${local.account_id}:log-group:aws-cloudtrail-logs-${local.account_id}:log-stream:${local.account_id}_CloudTrail_*",
    ]
  }
}

resource "aws_iam_role" "cloudtrail_logging" {
  provider           = aws.apse2
  name               = "aws-service-role-cloudtrail-logging"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_logging_trust_relationship.json
}

resource "aws_iam_role_policy" "cloudtrail_logging" {
  policy = data.aws_iam_policy_document.cloudtrail_logging_permissions.json
  role   = aws_iam_role.cloudtrail_logging.id
}

resource "aws_cloudtrail" "management_events" {
  provider                   = aws.apse2
  name                       = "management-events"
  is_multi_region_trail      = true
  s3_bucket_name             = "aws-cloudtrail-logs-${local.account_id}-7b61be50"
  cloud_watch_logs_group_arn = "arn:aws:logs:ap-southeast-2:${local.account_id}:log-group:aws-cloudtrail-logs-${local.account_id}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_logging.arn

  advanced_event_selector {
    name = "Management events selector"
    field_selector {
      field  = "eventCategory"
      equals = ["Management"]
    }
  }
}

data "aws_iam_policy_document" "apigateway_logging_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "apigateway_logging_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]
    resources = [
      "arn:aws:logs:*:${local.account_id}:log-group:*",
      "arn:aws:logs:*:${local.account_id}:log-group:*:log-stream:*",
    ]
  }
}

resource "aws_iam_role" "apigateway_logging" {
  provider           = aws.apse2
  name               = "aws-service-role-apigateway-logging"
  assume_role_policy = data.aws_iam_policy_document.apigateway_logging_trust_relationship.json
  inline_policy {
    name   = "InlinePolicy"
    policy = data.aws_iam_policy_document.apigateway_logging_permissions.json
  }
}

resource "aws_api_gateway_account" "logging" {
  provider            = aws.apse2
  cloudwatch_role_arn = aws_iam_role.apigateway_logging.arn
}
