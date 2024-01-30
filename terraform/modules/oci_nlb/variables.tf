variable "compartment_id" {
  type = string
}

variable "display_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "is_private" {
  type = bool
}

variable "backends" {
  type = map(object({
    target_id  = optional(string)
    ip_address = optional(string)
    protocol   = string
    port       = number
    health_check = optional(object({
      policy             = optional(string)
      retries            = optional(number)
      timeout_in_millis  = optional(number)
      interval_in_millis = optional(number)
    }))
  }))
  validation {
    condition = anytrue([
      for name, spec in var.backends :
      spec.target_id != null || spec.ip_address != null
    ])
    error_message = "At least one of target_id or ip_address must be defined"
  }
}
