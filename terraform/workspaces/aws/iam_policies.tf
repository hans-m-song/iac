data "aws_iam_policy_document" "assume_cdk_lookup_role" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${local.account_id}:role/cdk-toolkit-lookup-role-${local.account_id}-*"]
  }
}

resource "aws_iam_policy" "assume_cdk_lookup_role" {
  provider = aws.apse2
  name     = "assume-cdk-lookup-role-policy"
  policy   = data.aws_iam_policy_document.assume_cdk_lookup_role.json
}

data "aws_iam_policy_document" "assume_cdk_deploy_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    resources = [
      "arn:aws:iam::${local.account_id}:role/cdk-toolkit-deploy-role-${local.account_id}-*",
      "arn:aws:iam::${local.account_id}:role/cdk-toolkit-file-publishing-role-${local.account_id}-*",
      "arn:aws:iam::${local.account_id}:role/cdk-toolkit-image-publishing-role-${local.account_id}-*",
    ]
  }
}

resource "aws_iam_policy" "assume_cdk_deploy_role" {
  provider = aws.apse2
  name     = "assume-cdk-deploy-role-policy"
  policy   = data.aws_iam_policy_document.assume_cdk_deploy_role.json
}

data "aws_iam_policy_document" "ecr_publisher" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "sts:GetServiceBearerToken",
      "ecr-public:GetAuthorizationToken",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr-public:BatchCheckLayerAvailability",
      "ecr-public:GetRepositoryPolicy",
      "ecr-public:DescribeRepositories",
      "ecr-public:DescribeRegistries",
      "ecr-public:DescribeImages",
      "ecr-public:DescribeImageTags",
      "ecr-public:GetRepositoryCatalogData",
      "ecr-public:GetRegistryCatalogData",

      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr-public:BatchDeleteImage",
      "ecr-public:CompleteLayerUpload",
      "ecr-public:InitiateLayerUpload",
      "ecr-public:PutImage",
      "ecr-public:TagResource",
      "ecr-public:UntagResource",
      "ecr-public:UploadLayerPart",

      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecr_publisher" {
  provider = aws.apse2
  name     = "ecr-publisher-policy"
  policy   = data.aws_iam_policy_document.ecr_publisher.json
}

data "aws_iam_policy_document" "cloudfront_invalidator" {
  statement {
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
    ]
    resources = ["arn:aws:cloudfront::${local.account_id}:distribution/*"]
  }
}

resource "aws_iam_policy" "cloudfront_invalidator" {
  provider = aws.apse2
  name     = "cloudfront-invalidator-policy"
  policy   = data.aws_iam_policy_document.cloudfront_invalidator.json
}

data "aws_iam_policy_document" "user_access_self_service" {
  statement {
    effect = "Allow"
    actions = [
      "iam:List*",
      "iam:Get*",
      "iam:CreateVirtualMFADevice",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowSelfService"
    effect = "Allow"
    actions = [
      # user
      "iam:GetLoginProfile",
      "iam:UpdateLoginProfile",
      # password
      "iam:ChangePassword",
      # access key
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:UpdateAccessKey",
      "iam:GetAccessKeyLastUsed",
      # mfa
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:DeactivateMFADevice",
    ]
    resources = [
      "arn:aws:iam::*:user/$${aws:username}"
    ]
  }

  statement {
    sid    = "DenyAllIfNoMFA"
    effect = "Deny"
    not_actions = [
      "iam:List*",
      "iam:Get*",
      "iam:CreateVirtualMFADevice",
      "sts:GetCallerIdentity",
      "iam:GetLoginProfile",
      "iam:UpdateLoginProfile",
      "iam:ChangePassword",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
    ]
    resources = ["*"]
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}

resource "aws_iam_policy" "user_access_self_service" {
  provider = aws.apse2
  name     = "user-access-self-service-policy"
  policy   = data.aws_iam_policy_document.user_access_self_service.json
}
