variable "dockerhub_access_token" {
  description = "/infrastructure/octopus_deploy/dockerhub_access_token"
  type        = string
  sensitive   = true
}

variable "dockerhub_username" {
  description = "/infrastructure/octopus_deploy/dockerhub_username"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "/infrastructure/octopus_deploy/github_token"
  type        = string
  sensitive   = true
}
