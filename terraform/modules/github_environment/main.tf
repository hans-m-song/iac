resource "github_repository_environment" "this" {
  repository  = var.repository_name
  environment = var.name

  reviewers {
    teams = var.reviewing_teams
    users = var.reviewing_users
  }

  deployment_branch_policy {
    custom_branch_policies = length(var.branches) > 0
    protected_branches     = length(var.branches) < 1
  }
}

resource "github_repository_environment_deployment_policy" "this" {
  for_each       = toset(var.branches)
  repository     = var.repository_name
  environment    = github_repository_environment.this.environment
  branch_pattern = each.value
}
