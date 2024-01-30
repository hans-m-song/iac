module "jayd" {
  source                        = "./modules/project"
  providers                     = { github = github.axatol }
  github_repository_name        = "jayd"
  enable_actions_runner_webhook = true
  parameters                    = local.github_project_parameters
}

module "jayd_wheatley" {
  source          = "./modules/github_environment"
  providers       = { github = github.axatol }
  repository_name = module.jayd.github_repository_name
  name            = "wheatley"
  branches        = ["master"]
  reviewing_users = [local.github_user_id_hans_m_song]
}

# resource "octopusdeploy_project" "jayd" {
#   name                              = "JAYD"
#   project_group_id                  = octopusdeploy_project_group.kubernetes.id
#   lifecycle_id                      = octopusdeploy_lifecycle.production_only.id
#   tenanted_deployment_participation = "Tenanted"
# }

module "auth0_app_jayd_dev" {
  source         = "./modules/auth0_app"
  identifier     = "https://api.jayd.k8s.axatol.xyz"
  name           = "Just Another Youtube Downloader (dev)"
  client_origins = ["http://localhost:5173", "http://localhost:8001"]

  scopes = {
    "youtube:download" = "Permission to download youtube content"
    "youtube:metadata" = "Permission to retrieve youtube metadata"
  }
}

module "auth0_app_jayd" {
  source         = "./modules/auth0_app"
  identifier     = "https://api.jayd.axatol.xyz"
  name           = "Just Another Youtube Downloader"
  client_origins = ["https://jayd.axatol.xyz", "https://jayd.k8s.axatol.xyz"]

  scopes = {
    "youtube:download" = "Permission to download youtube content"
    "youtube:metadata" = "Permission to retrieve youtube metadata"
  }
}

resource "aws_ssm_parameter" "jayd_dev_domain" {
  name           = "/application/jayd/dev/domain"
  type           = "String"
  insecure_value = data.auth0_tenant.this.domain
}

resource "aws_ssm_parameter" "jayd_dev_client_id" {
  name           = "/application/jayd/dev/client_id"
  type           = "String"
  insecure_value = module.auth0_app_jayd_dev.client_id
}
