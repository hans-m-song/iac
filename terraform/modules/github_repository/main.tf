resource "github_actions_variable" "this" {
  for_each      = var.actions_variables
  repository    = var.repository_name
  variable_name = each.key
  value         = each.value
}

resource "github_actions_secret" "this" {
  for_each        = toset(nonsensitive(keys(var.actions_secrets)))
  repository      = var.repository_name
  secret_name     = each.key
  plaintext_value = var.actions_secrets[each.key]
}

resource "github_actions_repository_oidc_subject_claim_customization_template" "this" {
  repository  = var.repository_name
  use_default = false

  include_claim_keys = [
    "repo",
    "context",
    "actor",
  ]
}

resource "github_repository_webhook" "actions_runner" {
  count      = var.github_actions_webhook != "" ? 1 : 0
  repository = var.repository_name
  active     = true
  events     = ["workflow_job"]

  configuration {
    url          = var.github_actions_webhook
    content_type = "json"
  }
}

resource "github_repository_webhook" "new_relic" {
  count      = var.new_relic_license_key != "" ? 1 : 0
  repository = var.repository_name
  active     = true
  events     = ["workflow_job"]

  configuration {
    url          = "https://log-api.newrelic.com/log/v1?Api-Key=${var.new_relic_license_key}"
    content_type = "json"
  }
}

resource "github_repository_environment" "this" {
  for_each    = var.environments
  repository  = var.repository_name
  environment = each.key

  reviewers {
    teams = each.value.reviewing_teams
    users = each.value.reviewing_users
  }

  deployment_branch_policy {
    custom_branch_policies = length(each.value.branches) > 0
    protected_branches     = length(each.value.branches) < 1
  }
}

resource "github_repository_environment_deployment_policy" "this" {
  for_each = merge([
    for name, env in var.environments : {
      for branch in env.branches :
      "${name}:${branch}" => { environment = name, branch = branch }
    }
  ]...)
  repository     = var.repository_name
  environment    = each.value.environment
  branch_pattern = each.value.branch
}
