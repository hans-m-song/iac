variable "repository_name" {
  description = "(Required) GitHub repository name"
  type        = string
}

variable "actions_variables" {
  description = "(Optional) Variables to make available to workflows"
  type        = map(string)
  default     = {}
}

variable "actions_secrets" {
  description = "(Optional) Secrets to make available to workflows"
  type        = map(string)
  sensitive   = true
  default     = {}
}

variable "github_actions_webhook" {
  description = "(Optional) URL of a Github Actions Controller to deliver workflow_job events to"
  type        = string
  default     = ""
}

variable "new_relic_license_key" {
  description = "(Optional) License key used to deliver repository events to"
  type        = string
  sensitive   = true
  default     = ""
}

variable "environments" {
  description = "(Optional) Mapping of environment name to GitHub environment settings"
  type = map(object({
    reviewing_teams = optional(list(number))
    reviewing_users = optional(list(number))
    branches        = list(string)
  }))
  default = {}
}
