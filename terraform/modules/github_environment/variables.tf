variable "repository_name" {
  description = "(Required) Name of GitHub repository to create environment in"
  type        = string
}

variable "name" {
  description = "(Required) Environment name"
  type        = string
}

variable "reviewing_teams" {
  description = "(Optional) List of required team IDs to review deployments"
  type        = list(number)
  default     = []
}

variable "reviewing_users" {
  description = "(Optional) List of required user IDs to review deployments"
  type        = list(number)
  default     = []
}

variable "branches" {
  description = "(Optional) List of allowed branches"
  type        = list(string)
  default     = []
}
