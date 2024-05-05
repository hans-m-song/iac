variable "name" {
  description = "(Required) Name"
  type        = string
}

variable "policy_ids" {
  description = "(Required) List of policy ids to notify on"
  type        = list(string)
}

variable "webhook_url" {
  description = "(Required) Webhook delivery destination"
  type        = string
}

variable "webhook_format" {
  description = "(Required) Webhook payload format"
  type        = string
  validation {
    condition     = contains(["slack", "discord", "raw"], var.webhook_format)
    error_message = "webhook_format must be one of slack, discord, or raw"
  }
}

variable "tags" {
  description = "(Optional) Additional tags to attach to resources"
  type        = map(string)
  default     = {}
}
