terraform {
  backend "s3" {
    region         = "ap-southeast-2"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform-state-lock"
  }

  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 0.50.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 5.31.0"
    }

    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.26.0"
    }

    octopusdeploy = {
      source  = "OctopusDeployLabs/octopusdeploy"
      version = "~> 0.12.4"
    }
  }
}

provider "auth0" {
  domain        = var.auth0_domain
  client_id     = var.auth0_client_id
  client_secret = var.auth0_client_secret
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
  token = var.github_token
}

provider "github" {
  alias = "hans_m_song"
  owner = "hans-m-song"
  token = var.github_token
}

provider "newrelic" {
  account_id = var.new_relic_account_id
  api_key    = var.new_relic_api_key
}

provider "octopusdeploy" {
  address = "http://octopus.k8s.axatol.xyz"
  api_key = var.octopus_deploy_api_key
}
