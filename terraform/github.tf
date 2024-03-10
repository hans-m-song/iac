locals {
  github_user_id_hans_m_song = 21118015

  github_project_parameters = {
    github_actions_cdk_deploy_role_arn             = var.github_actions_cdk_deploy_role_arn
    github_actions_cdk_diff_role_arn               = var.github_actions_cdk_diff_role_arn
    github_actions_cloudfront_invalidator_role_arn = var.github_actions_cloudfront_invalidator_role_arn
    github_actions_discord_webhook_url             = var.github_actions_discord_webhook_url
    github_actions_ecr_image_publisher_role_arn    = var.github_actions_ecr_image_publisher_role_arn
    github_actions_new_relic_api_key               = var.github_actions_new_relic_api_key
    github_actions_runner_webhook_url              = var.github_actions_runner_webhook_url
    github_new_relic_license_key                   = var.github_new_relic_license_key
  }
}

module "actions" {
  source     = "./modules/project"
  providers  = { github = github.axatol }
  parameters = local.github_project_parameters

  github_repository_name        = "actions"
  enable_actions_runner_webhook = true
}

module "actions_job_dispatcher" {
  source     = "./modules/project"
  providers  = { github = github.axatol }
  parameters = local.github_project_parameters

  github_repository_name        = "actions-job-dispatcher"
  enable_actions_runner_webhook = true
}

module "external_dns_cloudflare_tunnel_webhook" {
  source     = "./modules/project"
  providers  = { github = github.axatol }
  parameters = local.github_project_parameters

  github_repository_name        = "external-dns-cloudflare-tunnel-webhook"
  enable_actions_runner_webhook = true
}

module "go_utils" {
  source     = "./modules/project"
  providers  = { github = github.axatol }
  parameters = local.github_project_parameters

  github_repository_name        = "go-utils"
  enable_actions_runner_webhook = true
}

module "terraform_provider_octopusdeploy" {
  source     = "./modules/project"
  providers  = { github = github.axatol }
  parameters = local.github_project_parameters

  github_repository_name        = "terraform-provider-octopusdeploy"
  enable_actions_runner_webhook = true
}
