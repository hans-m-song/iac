variable "aws_cdk_deploy_role_arn" {
  type = string
}

variable "aws_cdk_diff_role_arn" {
  type = string
}

variable "aws_cloudfront_invalidator_role_arn" {
  type = string
}

variable "aws_ecr_image_publisher_role_arn" {
  type = string
}

variable "aws_songmatrix_ecr_image_publisher_role_arn" {
  type = string
}

variable "discord_github_actions_webhook_url" {
  type      = string
  sensitive = true
}

variable "github_arc_webhook_url" {
  type = string
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "new_relic_license_key" {
  type      = string
  sensitive = true
}

resource "github_actions_organization_secret" "axatol" {
  for_each = {
    "AWS_DEFAULT_REGION"               = "ap-southeast-2"
    "AWS_ECR_IMAGE_PUBLISHER_ROLE_ARN" = var.aws_ecr_image_publisher_role_arn
  }

  provider        = github.axatol
  visibility      = "all"
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_actions_organization_secret" "songmatrix" {
  for_each = {
    "AWS_DEFAULT_REGION"                          = "ap-southeast-2"
    "AWS_SONGMATRIX_ECR_IMAGE_PUBLISHER_ROLE_ARN" = var.aws_songmatrix_ecr_image_publisher_role_arn
  }

  provider        = github.songmatrix
  visibility      = "all"
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_actions_secret" "hans_m_song-blog" {
  for_each = {
    "AWS_CDK_DEPLOY_ROLE_ARN"             = var.aws_cdk_deploy_role_arn
    "AWS_CDK_DIFF_ROLE_ARN"               = var.aws_cdk_diff_role_arn
    "AWS_DEFAULT_REGION"                  = "ap-southeast-2"
    "AWS_CLOUDFRONT_INVALIDATOR_ROLE_ARN" = var.aws_cloudfront_invalidator_role_arn
  }

  provider        = github.hans_m_song
  repository      = github_repository.hans_m_song-blog.name
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_actions_secret" "hans_m_song-huisheng" {
  for_each = {
    "AWS_DEFAULT_REGION"                 = "ap-southeast-2"
    "AWS_ECR_IMAGE_PUBLISHER_ROLE_ARN"   = var.aws_ecr_image_publisher_role_arn
    "DISCORD_GITHUB_ACTIONS_WEBHOOK_URL" = var.discord_github_actions_webhook_url
  }

  provider        = github.hans_m_song
  repository      = github_repository.hans_m_song-huisheng.name
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_actions_secret" "hans_m_song-iac" {
  for_each = {
    "AWS_CDK_DEPLOY_ROLE_ARN" = var.aws_cdk_deploy_role_arn
    "AWS_CDK_DIFF_ROLE_ARN"   = var.aws_cdk_diff_role_arn
    "AWS_DEFAULT_REGION"      = "ap-southeast-2"
    "TERRAFORM_VERSION"       = "1.3.7"
  }

  provider        = github.hans_m_song
  repository      = github_repository.hans_m_song-iac.name
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_actions_secret" "hans_m_song-kube_stack" {
  for_each = {
    "AWS_DEFAULT_REGION"               = "ap-southeast-2"
    "AWS_ECR_IMAGE_PUBLISHER_ROLE_ARN" = var.aws_ecr_image_publisher_role_arn
  }

  provider        = github.hans_m_song
  repository      = github_repository.hans_m_song-kube_stack.name
  secret_name     = each.key
  plaintext_value = each.value
}
