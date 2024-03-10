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
