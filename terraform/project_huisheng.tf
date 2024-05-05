module "huisheng_newrelic_application" {
  source = "./modules/newrelic_application"
  name   = "huisheng"

  alerts = {
    "error count" = {
      query = <<-EOT
        FROM Log
        SELECT count(*)
        WHERE namespace_name = 'huisheng' AND (error IS NOT NULL OR error.message IS NOT NULL)
        FACET error, error.message
      EOT

      aggregation_delay  = 0
      aggregation_window = 30

      warning = {}
    }
  }
}

module "huisheng_newrelic_workflow" {
  source         = "./modules/newrelic_workflow"
  name           = "huisheng"
  webhook_url    = var.new_relic_discord_webhook_url
  webhook_format = "discord"
  policy_ids     = [module.huisheng_newrelic_application.alert_policy_id]
}

module "huisheng_github_repository" {
  source          = "./modules/github_repository"
  providers       = { github = github.hans_m_song }
  repository_name = "huisheng"

  github_actions_webhook = var.github_actions_runner_webhook_url
  actions_secrets = merge(local.project_secrets, {
    NEW_RELIC_DEPLOYMENT_ENTITY_GUID = module.huisheng_newrelic_application.workload_guid
  })

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
