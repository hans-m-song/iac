variable "auth0_domain" {
  type      = string
  sensitive = true
}

variable "auth0_client_id" {
  type      = string
  sensitive = true
}

variable "auth0_client_secret" {
  type      = string
  sensitive = true
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "newrelic_account_id" {
  type      = string
  sensitive = true
}

variable "newrelic_api_key" {
  type      = string
  sensitive = true
}
