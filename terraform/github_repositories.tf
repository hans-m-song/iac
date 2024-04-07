module "actions_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.axatol }
  repository_name = "actions"

  github_actions_webhook = var.github_actions_runner_webhook_url
  actions_secrets        = local.project_secrets
}

module "actions_job_dispatcher_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.axatol }
  repository_name = "actions-job-dispatcher"

  github_actions_webhook = var.github_actions_runner_webhook_url
  actions_secrets        = local.project_secrets
}

module "blog_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.hans_m_song }
  repository_name = "blog"

  github_actions_webhook = var.github_actions_runner_webhook_url
  actions_secrets        = local.project_secrets

  environments = {
    "github-pages" = {
      branches = ["master"]
    }
  }
}

module "external_dns_cloudflare_tunnel_webhook_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.axatol }
  repository_name = "external-dns-cloudflare-tunnel-webhook"

  github_actions_webhook = var.github_actions_runner_webhook_url
  actions_secrets        = local.project_secrets
}

module "go_utils_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.axatol }
  repository_name = "go-utils"

  github_actions_webhook = var.github_actions_runner_webhook_url
  actions_secrets        = local.project_secrets
}

module "guosheng_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.axatol }
  repository_name = "guosheng"

  github_actions_webhook = var.github_actions_runner_webhook_url
  actions_secrets        = local.project_secrets

  environments = {
    "github-pages" = {
      branches = ["gh-pages"]
    }
    "production" = {
      branches        = ["master"]
      reviewing_users = [data.github_user.hans_m_song.id]
    }
  }
}

module "home_assistant_integrations_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.axatol }
  repository_name = "home-assistant-integrations"

  github_actions_webhook = var.github_actions_runner_webhook_url
  actions_secrets        = local.project_secrets

  environments = {
    "github-pages" = {
      branches        = ["gh-pages"]
      reviewing_users = [data.github_user.hans_m_song.id]
    }
  }
}

module "huisheng_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.hans_m_song }
  repository_name = "huisheng"

  github_actions_webhook = var.github_actions_runner_webhook_url
  actions_secrets        = local.project_secrets

  environments = {
    "github-pages" = {
      branches = ["gh-pages"]
    }
    "production" = {
      branches        = ["master"]
      reviewing_users = [data.github_user.hans_m_song.id]
    }
  }
}

module "iac_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.hans_m_song }
  repository_name = "iac"

  github_actions_webhook = var.github_actions_runner_webhook_url
  actions_secrets        = local.project_secrets
}

module "terraform_provider_octopusdeploycontrib_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.axatol }
  repository_name = "terraform-provider-octopusdeploycontrib"

  github_actions_webhook = var.github_actions_runner_webhook_url
}
