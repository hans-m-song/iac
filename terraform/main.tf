data "auth0_tenant" "this" {
}

data "aws_caller_identity" "current" {
}

data "aws_acm_certificate" "cloud_axatol_xyz" {
  provider = aws.use1
  domain   = "cloud.axatol.xyz"
}

# data "aws_acm_certificate" "hsong_me" {
#   provider = aws.use1
#   domain   = "hsong.me"
# }

data "github_user" "hans_m_song" {
  username = "hans-m-song"
}

data "cloudflare_zone" "axatol_xyz" {
  filter = {
    name = "axatol.xyz"
  }
}

resource "terraform_data" "test" {
  input = data.cloudflare_zone.axatol_xyz
}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id

  project_secrets = {
    AWS_CDK_DEPLOY_ROLE_ARN          = module.aws.cdk_deploy_github_actions_role_arn
    AWS_CDK_LOOKUP_ROLE_ARN          = module.aws.cdk_lookup_github_actions_role_arn
    AWS_ECR_IMAGE_PUBLISHER_ROLE_ARN = module.aws.ecr_publisher_github_actions_role_arn
    DISCORD_WEBHOOK_URL              = var.github_actions_discord_webhook_url
    SLACK_WEBHOOK_URL                = var.github_actions_slack_webhook_url
    NEW_RELIC_LICENSE_KEY            = var.github_actions_new_relic_license_key
  }

  slack_alerts_channel_id = "C05QK1T67JA"

  axatol_xyz_zone_id = data.cloudflare_zone.axatol_xyz.zone_id
}

module "auth0" {
  source = "./workspaces/auth0"
}

module "aws" {
  providers = {
    aws.apse2 = aws.apse2
    aws.use1  = aws.use1
  }
  source = "./workspaces/aws"
}

module "newrelic" {
  source              = "./workspaces/newrelic"
  discord_webhook_url = var.new_relic_discord_webhook_url
}

module "oci" {
  source              = "./workspaces/oci"
  oci_tenancy_ocid    = var.oci_tenancy_ocid
  ssh_authorized_keys = var.ssh_authorized_keys
}

module "zerotier" {
  source = "./workspaces/zerotier"
}

resource "cloudflare_dns_record" "grady_axatol_xyz" {
  zone_id = local.axatol_xyz_zone_id
  name    = "grady.axatol.xyz"
  ttl     = 1
  type    = "A"
  content = module.oci.grady_ip_address
}

resource "cloudflare_dns_record" "wildcard_grady_axatol_xyz" {
  zone_id = local.axatol_xyz_zone_id
  name    = "*.grady.axatol.xyz"
  ttl     = 1
  type    = "A"
  content = module.oci.grady_ip_address
}
