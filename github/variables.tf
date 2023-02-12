variable "github_token" {
  type      = string
  sensitive = true
}

variable "github_arc_webhook_url" {
  type = string
}

variable "aws_diff_role_arn" {
  type = string
}

variable "aws_deploy_role_arn" {
  type = string
}

variable "aws_ecr_image_publisher_role_arn" {
  type = string
}

variable "aws_songmatrix_ecr_image_publisher_role_arn" {
  type = string
}

resource "github_actions_organization_secret" "axatol_aws_ecr_image_publisher_role_arn" {
  provider        = github.axatol
  visibility      = "all"
  secret_name     = "AWS_ECR_IMAGE_PUBLISHER_ROLE_ARN"
  plaintext_value = var.aws_ecr_image_publisher_role_arn
}

resource "github_actions_organization_secret" "songmatrix_aws_songmatrix_ecr_image_publisher_role_arn" {
  provider        = github.songmatrix
  visibility      = "all"
  secret_name     = "AWS_SONGMATRIX_ECR_IMAGE_PUBLISHER_ROLE_ARN"
  plaintext_value = var.aws_songmatrix_ecr_image_publisher_role_arn
}

resource "github_actions_secret" "hans-m-song_huisheng_aws_ecr_image_publisher_role_arn" {
  provider        = github.hans-m-song
  repository      = github_repository.hans-m-song_huisheng.name
  secret_name     = "AWS_ECR_IMAGE_PUBLISHER_ROLE_ARN"
  plaintext_value = var.aws_ecr_image_publisher_role_arn
}

resource "github_actions_secret" "hans-m-song_iac_aws_deploy_role_arn" {
  provider        = github.hans-m-song
  repository      = github_repository.hans-m-song_iac.name
  secret_name     = "AWS_DEPLOY_ROLE_ARN"
  plaintext_value = var.aws_deploy_role_arn
}

resource "github_actions_secret" "hans-m-song_iac_aws_diff_role_arn" {
  provider        = github.hans-m-song
  repository      = github_repository.hans-m-song_iac.name
  secret_name     = "AWS_DIFF_ROLE_ARN"
  plaintext_value = var.aws_diff_role_arn
}

resource "github_actions_secret" "hans-m-song_iac_terraform_version" {
  provider        = github.hans-m-song
  repository      = github_repository.hans-m-song_iac.name
  secret_name     = "TERRAFORM_VERSION"
  plaintext_value = "1.3.7"
}

resource "github_actions_secret" "hans-m-song_kube-stack_aws_ecr_image_publisher_role_arn" {
  provider        = github.hans-m-song
  repository      = github_repository.hans-m-song_kube-stack.name
  secret_name     = "AWS_ECR_IMAGE_PUBLISHER_ROLE_ARN"
  plaintext_value = var.aws_ecr_image_publisher_role_arn
}
