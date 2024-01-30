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

# resource "octopusdeploy_project" "guosheng" {
#   name                              = "guosheng"
#   project_group_id                  = octopusdeploy_project_group.kubernetes.id
#   lifecycle_id                      = octopusdeploy_lifecycle.production_only.id
#   tenanted_deployment_participation = "Tenanted"
# }

module "guosheng_octopus_deploy_project" {
  source           = "./modules/octopus_deploy_project"
  name             = "guosheng"
  project_group_id = module.octopus_deploy.kubernetes_project_group_id
  lifecycle_id     = module.octopus_deploy.production_only_lifecycle_id

  helm_deployment = {
    chart_name   = "guosheng"
    namespace    = "guosheng"
    package_id   = "guosheng"
    release_name = "guosheng"
  }
}
