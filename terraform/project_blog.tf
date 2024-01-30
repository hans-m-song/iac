module "blog" {
  source                        = "./modules/project"
  providers                     = { github = github.hans_m_song }
  parameters                    = local.github_project_parameters
  github_repository_name        = "blog"
  enable_actions_runner_webhook = true
  enable_new_relic_webhook      = true
}

module "blog_github_pages" {
  source          = "./modules/github_environment"
  providers       = { github = github.hans_m_song }
  name            = "github-pages"
  repository_name = module.blog.github_repository_name
  branches        = ["master"]
}

module "blog_public" {
  source          = "./modules/github_environment"
  providers       = { github = github.hans_m_song }
  name            = "public"
  repository_name = module.blog.github_repository_name
  branches        = ["master"]
}

# resource "octopusdeploy_project" "blog" {
#   name                              = "Blog"
#   project_group_id                  = module.octopus_deploy.kubernetes_project_group_id
#   lifecycle_id                      = module.octopus_deploy.production_only_lifecycle_id
#   tenanted_deployment_participation = "Tenanted"
# }

# module "blog_octopus_deploy_project" {
#   source           = "./modules/octopus_deploy_project"
#   name             = "blog"
#   project_group_id = module.octopus_deploy.kubernetes_project_group_id
#   lifecycle_id     = module.octopus_deploy.production_only_lifecycle_id

#   cdk_deployment = {
#     package_id = "blog"
#     feed_id    = module.octopus_deploy.built_in_feed_id
#   }
# }
