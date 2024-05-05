variable "name" {
  description = "(Required) Workload name"
  type        = string
}

variable "alerts" {
  description = "(Optional) Queries that would raise an incident"
  type = map(object({
    query = string

    type                         = optional(string)
    aggregation_method           = optional(string)
    aggregation_delay            = optional(number)
    aggregation_window           = optional(number)
    evaluation_delay             = optional(number)
    violation_time_limit_seconds = optional(number)

    warning = optional(object({
      operator              = optional(string)
      threshold             = optional(number)
      threshold_duration    = optional(number)
      threshold_occurrences = optional(string)
    }))

    critical = optional(object({
      operator              = optional(string)
      threshold             = optional(number)
      threshold_duration    = optional(number)
      threshold_occurrences = optional(string)
    }))
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) Additional tags to attach to resources"
  type        = map(string)
  default     = {}
}
