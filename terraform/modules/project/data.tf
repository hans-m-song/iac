data "aws_ssm_parameter" "github_actions_cdk_deploy_role_arn" {
  count = var.enable_aws_cdk_deploy ? 1 : 0
  name  = "/infrastructure/github/actions_cdk_deploy_role_arn"
}

data "aws_ssm_parameter" "github_actions_cdk_diff_role_arn" {
  count = var.enable_aws_cdk_deploy ? 1 : 0
  name  = "/infrastructure/github/actions_cdk_diff_role_arn"
}

data "aws_ssm_parameter" "github_actions_ecr_image_publisher_role_arn" {
  count = var.enable_aws_ecr_publish ? 1 : 0
  name  = "/infrastructure/github/actions_ecr_image_publisher_role_arn"
}

data "aws_ssm_parameter" "github_actions_runner_webhook_url" {
  count = var.enable_actions_runner_webhook ? 1 : 0
  name  = "/infrastructure/github/actions_runner_webhook_url"
}

data "aws_ssm_parameter" "new_relic_license_key" {
  count = var.enable_new_relic_webhook ? 1 : 0
  name  = "/infrastructure/new_relic/license_key"
}

data "github_repository" "this" {
  name = var.github_repository_name
}
