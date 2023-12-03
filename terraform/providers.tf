provider "auth0" {
  domain        = var.auth0_domain
  client_id     = var.terraform_auth0_client_id
  client_secret = var.terraform_auth0_client_secret
}

provider "aws" {
  alias  = "ap_southeast_2"
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "github" {
  alias = "axatol"
  owner = "axatol"
  token = var.terraform_github_token
}

provider "github" {
  alias = "hans_m_song"
  owner = "hans-m-song"
  token = var.terraform_github_token
}

provider "newrelic" {
  account_id = var.new_relic_account_id
  api_key    = var.terraform_new_relic_api_key
}

provider "oci" {
  tenancy_ocid = var.oci_tenancy_ocid
  user_ocid    = var.oci_user_ocid
  fingerprint  = var.terraform_oci_fingerprint
  private_key  = var.terraform_oci_api_private_key
}

provider "octopusdeploy" {
  address = "http://octopus.k8s.axatol.xyz"
  api_key = var.terraform_octopus_deploy_api_key
}

provider "zerotier" {
  zerotier_central_token = var.terraform_zerotier_token
}
