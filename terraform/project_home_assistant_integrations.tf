module "home_assistant_integrations" {
  source                        = "./modules/project"
  providers                     = { github = github.axatol }
  github_repository_name        = "home-assistant-integrations"
  enable_actions_runner_webhook = true
  parameters                    = local.github_project_parameters

  github_repository_actions_variables = {
    OCTOPUS_DEPLOY_SERVER_URL  = var.octopus_deploy_server_url
    OCTOPUS_DEPLOY_SPACE       = "Default"
    OCTOPUS_DEPLOY_PACKAGE_ID  = "home-assistant-integrations"
    OCTOPUS_DEPLOY_EXTERNAL_ID = octopusdeploycontrib_service_account_oidc_identity.huisheng_executor.external_id
  }
}

resource "octopusdeploycontrib_service_account_oidc_identity" "huisheng_executor" {
  user_id = module.octopus_deploy.executor_user_id
  name    = "GitHub - huisheng:v2"
  issuer  = "https://token.actions.githubusercontent.com"
  subject = "repo:axatol/home-assistant-integrations:ref:refs/heads/v2"
}

module "home_assistant_integrations_octopus_deploy_project" {
  source           = "./modules/octopus_deploy_project"
  name             = "home-assistant-integrations"
  project_group_id = module.octopus_deploy.kubernetes_project_group_id
  lifecycle_id     = module.octopus_deploy.production_only_lifecycle_id
  server_url       = var.octopus_deploy_server_url

  helm_deployment = {
    chart_name   = "home-assistant-integrations"
    namespace    = "home-assistant"
    package_id   = "home-assistant-integrations"
    release_name = "home-assistant-integrations"
  }
}

resource "octopusdeploycontrib_tenant_connection" "home_assistant_integrations_wheatley" {
  tenant_id       = module.octopus_deploy.wheatley_tenant_id
  project_id      = module.home_assistant_integrations_octopus_deploy_project.project_id
  environment_ids = [module.octopus_deploy.production_environment_id]
}
