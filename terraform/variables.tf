variable "auth0_domain" {
  description = "/infrastructure/auth0_domain"
  type        = string
  sensitive   = false
}

variable "github_actions_cdk_deploy_role_arn" {
  description = "/infrastructure/github_actions/cdk_deploy_role_arn"
  type        = string
  sensitive   = false
}

variable "github_actions_cdk_diff_role_arn" {
  description = "/infrastructure/github_actions/cdk_diff_role_arn"
  type        = string
  sensitive   = false
}

variable "github_actions_cloudfront_invalidator_role_arn" {
  description = "/infrastructure/github_actions/cloudfront_invalidator_role_arn"
  type        = string
  sensitive   = false
}

variable "github_actions_discord_webhook_url" {
  description = "/infrastructure/github_actions/discord_webhook_url"
  type        = string
  sensitive   = true
}

variable "github_actions_ecr_image_publisher_role_arn" {
  description = "/infrastructure/github_actions/ecr_image_publisher_role_arn"
  type        = string
  sensitive   = false
}

variable "github_actions_new_relic_api_key" {
  description = "/infrastructure/github_actions/new_relic_api_key"
  type        = string
  sensitive   = true
}

variable "github_actions_runner_webhook_url" {
  description = "/infrastructure/github_actions/runner_webhook_url"
  type        = string
  sensitive   = false
}

variable "github_new_relic_license_key" {
  description = "/infrastructure/github/new_relic_license_key"
  type        = string
  sensitive   = true
}

variable "new_relic_account_id" {
  description = "/infrastructure/new_relic/account_id"
  type        = string
  sensitive   = true
}

variable "new_relic_discord_webhook_url" {
  description = "/infrastructure/new_relic/discord_webhook_url"
  type        = string
  sensitive   = true
}

variable "octopus_deploy_dockerhub_access_token" {
  description = "/infrastructure/octopus_deploy/dockerhub_access_token"
  type        = string
  sensitive   = true
}

variable "octopus_deploy_dockerhub_username" {
  description = "/infrastructure/octopus_deploy/dockerhub_username"
  type        = string
  sensitive   = true
}

variable "octopus_deploy_github_token" {
  description = "/infrastructure/octopus_deploy/github_token"
  type        = string
  sensitive   = true
}

variable "terraform_auth0_client_id" {
  description = "/infrastructure/terraform/auth0_client_id"
  type        = string
  sensitive   = true
}

variable "terraform_auth0_client_secret" {
  description = "/infrastructure/terraform/auth0_client_secret"
  type        = string
  sensitive   = true
}

variable "terraform_github_token" {
  description = "/infrastructure/terraform/github_token"
  type        = string
  sensitive   = true
}

variable "terraform_new_relic_api_key" {
  description = "/infrastructure/terraform/new_relic_api_key"
  type        = string
  sensitive   = true
}

variable "terraform_octopus_deploy_api_key" {
  description = "/infrastructure/terraform/octopus_deploy_api_key"
  type        = string
  sensitive   = true
}
