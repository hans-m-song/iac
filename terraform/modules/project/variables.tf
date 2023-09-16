variable "enable_actions_runner_webhook" {
  description = "(Optional) Webhook destination for self-hosted actions runners"
  type        = bool
  default     = false
}

variable "enable_aws_cdk_deploy" {
  description = "(Optional) Provide configuration to assume CDK roles"
  type        = bool
  default     = false
}

variable "enable_aws_ecr_publish" {
  description = "(Optional) Provide configuration to allow pushing to ECR"
  type        = bool
  default     = false
}

variable "enable_discord_notifications" {
  description = "(Optional) Provide configuration to allow publishing a notification to discord"
  type        = bool
  default     = false
}

variable "enable_new_relic_api" {
  description = "(Optional) Provide configuration to access New Relic API"
  type        = bool
  default     = false
}

variable "enable_new_relic_webhook" {
  description = "(Optional) Configure webhooks for New Relic"
  type        = bool
  default     = false
}

variable "github_repository_name" {
  description = "(Required) GitHub repository name"
  type        = string
}

variable "github_repository_actions_variables" {
  description = "(Optional) Variables to make available to workflows"
  type        = map(string)
  default     = {}
}

variable "github_repository_actions_secrets" {
  description = "(Optional) Secrets to make available to workflows"
  type        = map(string)
  default     = {}
}

variable "parameters" {
  description = "(Required) Configuration values"
  sensitive   = true
  type = object({
    github_actions_cdk_deploy_role_arn             = string
    github_actions_cdk_diff_role_arn               = string
    github_actions_cloudfront_invalidator_role_arn = string
    github_actions_discord_webhook_url             = string
    github_actions_ecr_image_publisher_role_arn    = string
    github_actions_new_relic_api_key               = string
    github_actions_runner_webhook_url              = string
    github_new_relic_license_key                   = string
  })
}
