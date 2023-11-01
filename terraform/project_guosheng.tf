module "guosheng" {
  source                        = "./modules/project"
  providers                     = { github = github.axatol }
  github_repository_name        = "guosheng"
  enable_actions_runner_webhook = true
  parameters                    = local.github_project_parameters
}

module "guosheng_github_pages" {
  source          = "./modules/github_environment"
  providers       = { github = github.axatol }
  repository_name = module.guosheng.github_repository_name
  name            = "github-pages"
  branches        = ["gh-pages"]
}

module "guosheng_production" {
  source          = "./modules/github_environment"
  providers       = { github = github.axatol }
  repository_name = module.guosheng.github_repository_name
  name            = "production"
  branches        = ["master"]
  reviewing_users = [local.github_user_id_hans_m_song]
}

resource "octopusdeploy_project" "guosheng" {
  name                              = "guosheng"
  project_group_id                  = octopusdeploy_project_group.kubernetes.id
  lifecycle_id                      = octopusdeploy_lifecycle.production_only.id
  tenanted_deployment_participation = "Tenanted"
}
