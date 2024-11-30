variable "oci_tenancy_ocid" {
  description = "/infrastructure/oci/tenancy_ocid"
  type        = string
  sensitive   = true
}

variable "openssh_public_keys" {
  description = "/infrastructure/ssh/openssh_public_keys"
  type        = string
  sensitive   = false
}
