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
      version = "~> 6.54.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.22.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.13.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.6.0"
    }

    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.94.0"
    }

    oci = {
      source  = "oracle/oci"
      version = "~> 8.22.0"
    }

    openobserve = {
      source  = "openobserve/openobserve"
      version = "~> 1.3.0"
    }

    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.29.0"
    }

    zerotier = {
      source  = "zerotier/zerotier"
      version = "1.6.0"
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

  default_tags {
    tags = { "managed-by-terraform" = "true" }
  }
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"

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
  user_ocid    = var.oci_terraform_user_ocid
  fingerprint  = var.oci_terraform_api_key_fingerprint
  private_key  = var.oci_terraform_api_private_key
  region       = "ap-sydney-1"
}

provider "tailscale" {
  tailnet             = var.tailscale_tailnet_id
  oauth_client_id     = var.tailscale_oauth_client_id
  oauth_client_secret = var.tailscale_oauth_client_secret
}

provider "zerotier" {
  zerotier_central_token = var.zerotier_terraform_token
}
