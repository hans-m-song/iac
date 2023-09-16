module "huisheng" {
  source                        = "./modules/project"
  providers                     = { github = github.hans_m_song }
  github_repository_name        = "huisheng"
  enable_actions_runner_webhook = true
  parameters                    = local.github_project_parameters
}

module "huisheng_github_pages" {
  source          = "./modules/github_environment"
  providers       = { github = github.hans_m_song }
  repository_name = module.huisheng.github_repository_name
  name            = "github-pages"
  branches        = ["gh-pages"]
}

module "huisheng_wheatley" {
  source          = "./modules/github_environment"
  providers       = { github = github.hans_m_song }
  repository_name = module.huisheng.github_repository_name
  name            = "wheatley"
  branches        = ["master"]
  reviewing_users = [local.github_user_id_hans_m_song]
}

resource "octopusdeploy_project" "huisheng" {
  name                              = "Huisheng"
  project_group_id                  = octopusdeploy_project_group.kubernetes.id
  lifecycle_id                      = octopusdeploy_lifecycle.production_only.id
  tenanted_deployment_participation = "Tenanted"
}
