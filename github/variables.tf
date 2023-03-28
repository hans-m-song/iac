variable "aws_deploy_role_arn" {
  type = string
}

variable "aws_diff_role_arn" {
  type = string
}

variable "aws_ecr_image_publisher_role_arn" {
  type = string
}

variable "aws_songmatrix_ecr_image_publisher_role_arn" {
  type = string
}

variable "new_relic_license_key" {
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

locals {
  github_user_hans_m_song = 21118015
}

resource "github_actions_organization_secret" "axatol-aws_ecr_image_publisher_role_arn" {
  provider        = github.axatol
  visibility      = "all"
  secret_name     = "AWS_ECR_IMAGE_PUBLISHER_ROLE_ARN"
  plaintext_value = var.aws_ecr_image_publisher_role_arn
}

resource "github_actions_organization_secret" "songmatrix-aws_songmatrix_ecr_image_publisher_role_arn" {
  provider        = github.songmatrix
  visibility      = "all"
  secret_name     = "AWS_SONGMATRIX_ECR_IMAGE_PUBLISHER_ROLE_ARN"
  plaintext_value = var.aws_songmatrix_ecr_image_publisher_role_arn
}

resource "github_actions_secret" "hans_m_song-blog-aws_deploy_role_arn" {
  provider        = github.hans_m_song
  repository      = github_repository.hans_m_song-blog.name
  secret_name     = "AWS_DEPLOY_ROLE_ARN"
  plaintext_value = var.aws_deploy_role_arn
}

resource "github_actions_secret" "hans_m_song-blog-aws_diff_role_arn" {
  provider        = github.hans_m_song
  repository      = github_repository.hans_m_song-blog.name
  secret_name     = "AWS_DIFF_ROLE_ARN"
  plaintext_value = var.aws_diff_role_arn
}

resource "github_actions_secret" "hans_m_song-huisheng_aws_ecr_image_publisher_role_arn" {
  provider        = github.hans_m_song
  repository      = github_repository.hans_m_song-huisheng.name
  secret_name     = "AWS_ECR_IMAGE_PUBLISHER_ROLE_ARN"
  plaintext_value = var.aws_ecr_image_publisher_role_arn
}

resource "github_actions_secret" "hans_m_song-iac-aws_deploy_role_arn" {
  provider        = github.hans_m_song
  repository      = github_repository.hans_m_song-iac.name
  secret_name     = "AWS_DEPLOY_ROLE_ARN"
  plaintext_value = var.aws_deploy_role_arn
}

resource "github_actions_secret" "hans_m_song-iac-aws_diff_role_arn" {
  provider        = github.hans_m_song
  repository      = github_repository.hans_m_song-iac.name
  secret_name     = "AWS_DIFF_ROLE_ARN"
  plaintext_value = var.aws_diff_role_arn
}

resource "github_actions_secret" "hans_m_song-iac-terraform_version" {
  provider        = github.hans_m_song
  repository      = github_repository.hans_m_song-iac.name
  secret_name     = "TERRAFORM_VERSION"
  plaintext_value = "1.3.7"
}

resource "github_actions_secret" "hans_m_song-kube_stack-aws_ecr_image_publisher_role_arn" {
  provider        = github.hans_m_song
  repository      = github_repository.hans_m_song-kube_stack.name
  secret_name     = "AWS_ECR_IMAGE_PUBLISHER_ROLE_ARN"
  plaintext_value = var.aws_ecr_image_publisher_role_arn
}
