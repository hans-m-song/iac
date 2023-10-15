variable "policy_id" {
  description = "(Required) The ID of the policy where this condition should be used."
  type        = string
}

variable "cert_check_domains" {
  description = "(Optional) List of domains to check for certificate expiry"
  type        = list(string)
}
