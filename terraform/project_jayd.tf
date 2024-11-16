module "jayd_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.axatol }
  repository_name = "jayd"

  actions_secrets = local.project_secrets

  environments = {
    "production" = {
      branches        = ["master"]
      reviewing_users = [data.github_user.hans_m_song.id]
    }
  }
}

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
