variable "scopes" {
  description = "(Optional) Mapping of scope name to description"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "(Required) Friendly name for the resource server and client."
  type        = string
}

variable "identifier" {
  description = "(Required) Unique identifier for the resource server. Used as the audience parameter for authorization calls. Cannot be changed once set."
  type        = string
}

variable "client_origins" {
  description = "(Required) URLs that represent valid origins for client access."
  type        = list(string)
}
