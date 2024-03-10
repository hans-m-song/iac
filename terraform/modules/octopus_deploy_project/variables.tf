variable "server_url" {
  type = string
}

variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "project_group_id" {
  type = string
}

variable "lifecycle_id" {
  type = string
}

variable "kubernetes_deployment" {
  type = object({
    namespace = string
    files     = list(string)
  })
  nullable = true
  default  = null
}

variable "helm_deployment" {
  type = object({
    chart_name   = string
    release_name = string
    namespace    = string
    package_id   = string
    feed_id      = optional(string)
    tenant_tags  = optional(list(string))
    target_roles = optional(list(string))
  })
  nullable = true
  default  = null
}

variable "cdk_deployment" {
  type = object({
    package_id   = string
    feed_id      = optional(string)
    tenant_tags  = optional(list(string))
    target_roles = optional(list(string))
  })
  nullable = true
  default  = null
}
