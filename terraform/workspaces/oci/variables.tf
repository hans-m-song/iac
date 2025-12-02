variable "oci_tenancy_ocid" {
  description = "/infrastructure/oci/tenancy_ocid"
  type        = string
  sensitive   = true
}

variable "ssh_authorized_keys" {
  description = "/infrastructure/ssh/authorized_keys"
  type        = string
  sensitive   = false
}
