variable "domain_name" {
  description = "(Required) The name of the ACM certificate"
  type        = string
}

variable "zone_id" {
  description = "(Required) The ID of the Route 53 hosted zone to create the validation records in"
  type        = string
}

variable "subject_alternative_names" {
  description = "(Optional) A list of domains that should be SANs in the ACM certificate"
  type        = list(string)
  default     = []
}
