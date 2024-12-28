module "actions_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.axatol }
  repository_name = "actions"

  actions_secrets = local.project_secrets
}

module "actions_job_dispatcher_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.axatol }
  repository_name = "actions-job-dispatcher"

  actions_secrets = local.project_secrets
}

module "blog_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.hans_m_song }
  repository_name = "blog"

  actions_secrets = local.project_secrets

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

  actions_secrets = local.project_secrets
}

module "go_utils_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.axatol }
  repository_name = "go-utils"

  actions_secrets = local.project_secrets
}

module "guosheng_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.axatol }
  repository_name = "guosheng"

  actions_secrets = local.project_secrets

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

  actions_secrets = local.project_secrets

  environments = {
    "github-pages" = {
      branches        = ["gh-pages"]
      reviewing_users = [data.github_user.hans_m_song.id]
    }
  }
}

module "iac_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.hans_m_song }
  repository_name = "iac"

  actions_secrets = merge(local.project_secrets, {
    AWS_ACCOUNT_ID = local.aws_account_id
  })
}

module "shrodinger_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.hans_m_song }
  repository_name = "shrodinger"

  actions_secrets = local.project_secrets

  environments = {
    "production" = {
      branches        = ["master"]
      reviewing_users = [data.github_user.hans_m_song.id]
    }
  }
}

module "terraform_provider_octopusdeploycontrib_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.axatol }
  repository_name = "terraform-provider-octopusdeploycontrib"

}


module "address_search_lib_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.hans_m_song }
  repository_name = "address-search-lib"

  actions_secrets = local.project_secrets
}
