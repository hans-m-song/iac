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
      version = "~> 3.25.2"
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
  account_id = var.newrelic_account_id
  api_key    = var.newrelic_api_key
}
