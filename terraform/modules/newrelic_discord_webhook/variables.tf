variable "name" {
  description = "(Required) Name to use for workflow, channel, and destination"
}

variable "webhook_url" {
  description = "(Required) Discord webhook url"
  type        = string
}
