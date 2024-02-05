terraform {
  backend "s3" {
    region         = "ap-southeast-2"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform-state-lock"
  }

  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "1.0.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.25.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.21.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 5.42.0"
    }

    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.27.7"
    }

    oci = {
      source  = "oracle/oci"
      version = "~> 5.15.0"
    }

    octopusdeploy = {
      source  = "OctopusDeployLabs/octopusdeploy"
      version = "~> 0.13.2"
    }

    octopusdeploycontrib = {
      source  = "axatol/octopusdeploycontrib"
      version = "~> 0.0.3"
    }

    zerotier = {
      source  = "zerotier/zerotier"
      version = "1.4.2"
    }
  }
}

provider "auth0" {
  domain        = var.auth0_domain
  client_id     = var.auth0_terraform_client_id
  client_secret = var.auth0_terraform_client_secret
}

provider "aws" {
  alias  = "ap_southeast_2"
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "cloudflare" {
  api_token = var.cloudflare_terraform_api_token
}

provider "github" {
  alias = "axatol"
  owner = "axatol"
  token = var.github_terraform_token
}

provider "github" {
  alias = "hans_m_song"
  owner = "hans-m-song"
  token = var.github_terraform_token
}

provider "newrelic" {
  account_id = var.new_relic_account_id
  api_key    = var.new_relic_terraform_api_key
}

provider "oci" {
  tenancy_ocid = var.oci_tenancy_ocid
  user_ocid    = var.oci_user_ocid
  fingerprint  = var.oci_terraform_fingerprint
  private_key  = var.oci_terraform_api_private_key
  region       = var.oci_region
}

provider "octopusdeploy" {
  address = "http://octopus.axatol.local"
  api_key = var.octopus_deploy_terraform_api_key
}

provider "zerotier" {
  zerotier_central_token = var.zerotier_terraform_token
}
