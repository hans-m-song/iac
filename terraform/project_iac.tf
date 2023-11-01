module "iac" {
  source     = "./modules/project"
  providers  = { github = github.hans_m_song }
  parameters = local.github_project_parameters

  github_repository_name        = "iac"
  enable_actions_runner_webhook = true
  enable_new_relic_webhook      = true
}

resource "octopusdeploy_project" "iac" {
  name                              = "iac"
  project_group_id                  = octopusdeploy_project_group.kubernetes.id
  lifecycle_id                      = octopusdeploy_lifecycle.production_only.id
  tenanted_deployment_participation = "Tenanted"
}
