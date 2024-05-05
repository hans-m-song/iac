terraform {
  backend "s3" {
  }

  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "1.2.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "5.45.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.29.0"
    }

    github = {
      source  = "integrations/github"
      version = "6.2.1"
    }

    http = {
      source  = "hashicorp/http"
      version = "3.4.2"
    }

    newrelic = {
      source  = "newrelic/newrelic"
      version = "3.34.1"
    }

    oci = {
      source  = "oracle/oci"
      version = "5.36.0"
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
  alias  = "apse2"
  region = "ap-southeast-2"

  assume_role {
    role_arn = var.terraform_deploy_role
  }

  default_tags {
    tags = { "managed-by-terraform" = "true" }
  }
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"

  assume_role {
    role_arn = var.terraform_deploy_role
  }

  default_tags {
    tags = { "managed-by-terraform" = "true" }
  }
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

provider "http" {
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

provider "zerotier" {
  zerotier_central_token = var.zerotier_terraform_token
}
