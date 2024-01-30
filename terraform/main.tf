module "auth0" {
  source = "./workspaces/auth0"
}

module "new_relic" {
  source              = "./workspaces/new_relic"
  discord_webhook_url = var.new_relic_discord_webhook_url
}

module "octopus_deploy" {
  source                 = "./workspaces/octopus_deploy"
  dockerhub_access_token = var.octopus_deploy_dockerhub_access_token
  dockerhub_username     = var.octopus_deploy_dockerhub_username
  github_token           = var.octopus_deploy_github_token
}

module "zerotier" {
  source = "./workspaces/zerotier"
}
