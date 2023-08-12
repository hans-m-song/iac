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
