module "blog" {
  source                        = "./modules/project"
  providers                     = { github = github.hans_m_song }
  parameters                    = local.github_project_parameters
  github_repository_name        = "blog"
  enable_actions_runner_webhook = true
  enable_new_relic_webhook      = true
}

module "blog_public" {
  source          = "./modules/github_environment"
  providers       = { github = github.hans_m_song }
  name            = "public"
  repository_name = module.blog.github_repository_name
  branches        = ["master"]
}

resource "octopusdeploy_project" "blog" {
  name                              = "Blog"
  project_group_id                  = octopusdeploy_project_group.kubernetes.id
  lifecycle_id                      = octopusdeploy_lifecycle.production_only.id
  tenanted_deployment_participation = "Tenanted"
}
