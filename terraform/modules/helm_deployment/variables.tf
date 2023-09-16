variable "project_id" {
  description = "(Required) The project ID associated with this deployment process."
  type        = string
}

variable "feed_id" {
  description = "(Required) The feed ID associated with this package reference."
  type        = string
}

variable "package_id" {
  description = "(Required) The ID of the package."
  type        = string
}

# execution environment

variable "worker_pool_id" {
  description = "The worker pool associated with this deployment action."
  type        = string
  default     = ""
}

variable "target_roles" {
  description = "(Optional) The roles that this step run against, or runs on behalf of."
  type        = list(string)
  default     = []
}

variable "tenant_tags" {
  description = "(Optional) A list of tenant tags associated with this resource."
  type        = list(string)
  default     = []
}

# helm

variable "release_name" {
  description = "(Required) Helm chart release name."
  type        = string
}

variable "release_namespace" {
  description = "(Required) Specify the namespace the chart will be installed into."
  type        = string
}

variable "release_values" {
  description = "(Optional) Chart values."
  type        = map(string)
  default     = {}
}
