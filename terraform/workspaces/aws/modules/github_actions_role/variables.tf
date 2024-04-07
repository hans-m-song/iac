variable "name" {
  type = string
}

variable "provider_id" {
  type    = string
  default = "token.actions.githubusercontent.com"

}

variable "client_ids" {
  type    = list(string)
  default = ["sts.amazonaws.com"]
}

variable "subject_claims" {
  type = list(object({
    repo         = string
    branch       = optional(string)
    tag          = optional(string)
    environment  = optional(string)
    pull_request = optional(bool)
    actor        = string
  }))
  validation {
    condition = length(var.subject_claims) > 0 && length([
      for claim in var.subject_claims : claim if
      try(claim.branch, "") == "" &&
      try(claim.tag, "") == "" &&
      try(claim.environment, "") == "" &&
      try(claim.pull_request, false) == false
    ]) < 1
    error_message = "Must specify one of branch, tag, environment, or pull_request"
  }
}

variable "max_session_duration" {
  type    = number
  default = null
}

variable "permissions_boundary" {
  type    = string
  default = null
}

variable "managed_policy_arns" {
  type    = list(string)
  default = []
}
