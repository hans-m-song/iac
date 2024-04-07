variable "auth0_domain" {
  description = "/infrastructure/auth0_domain"
  type        = string
  sensitive   = false
}

variable "auth0_terraform_client_id" {
  description = "/infrastructure/auth0/terraform_client_id"
  type        = string
  sensitive   = true
}

variable "auth0_terraform_client_secret" {
  description = "/infrastructure/auth0/terraform_client_secret"
  type        = string
  sensitive   = true
}

variable "cloudflare_terraform_api_token" {
  description = "/infrastructure/cloudflare/terraform_api_token"
  type        = string
  sensitive   = true
}

variable "github_actions_discord_webhook_url" {
  description = "/infrastructure/github_actions/discord_webhook_url"
  type        = string
  sensitive   = true
}

variable "github_actions_runner_webhook_url" {
  description = "/infrastructure/github_actions/runner_webhook_url"
  type        = string
  sensitive   = false
}

variable "github_actions_slack_webhook_url" {
  description = "/infrastructure/github_actions/slack_webhook_url"
  type        = string
  sensitive   = true
}

variable "github_new_relic_license_key" {
  description = "/infrastructure/github/new_relic_license_key"
  type        = string
  sensitive   = true
}

variable "github_terraform_token" {
  description = "/infrastructure/github/terraform_token"
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

variable "new_relic_terraform_api_key" {
  description = "/infrastructure/new_relic/terraform_api_key"
  type        = string
  sensitive   = true
}

variable "oci_tenancy_ocid" {
  description = "TODO"
  type        = string
  sensitive   = true
}

variable "oci_user_ocid" {
  description = "TODO"
  type        = string
  sensitive   = true
}

variable "oci_terraform_fingerprint" {
  description = "TODO"
  type        = string
  sensitive   = true
}

variable "oci_terraform_api_private_key" {
  description = "TODO"
  type        = string
  sensitive   = true
}

variable "oci_region" {
  description = "TODO"
  type        = string
  sensitive   = true
}

variable "terraform_deploy_role" {
  description = "/infrastructure/terraform/deploy_role_arn"
  type        = string
  sensitive   = true
}

variable "zerotier_terraform_token" {
  description = "/infrastructure/zerotier/terraform_token"
  type        = string
  sensitive   = true
}
