variable "github_token" {
  type      = string
  sensitive = true
}

variable "github_arc_webhook_url" {
  type = string
}

variable "aws_deploy_role_arn" {
  type = string
}

resource "github_actions_secret" "hans-m-song_iac_aws_deploy_role_arn" {
  provider   = github.hans-m-song
  repository = github_repository.hans-m-song_iac.name

  secret_name     = "aws_deploy_role_arn"
  plaintext_value = var.aws_deploy_role_arn
}
