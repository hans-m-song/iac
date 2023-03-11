terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "deep-thought"

    workspaces {
      name = "iac-github"
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.16.0"
    }
  }
}

provider "github" {
  owner = "hans-m-song"
  alias = "hans_m_song"
  token = var.github_token
}

provider "github" {
  owner = "axatol"
  alias = "axatol"
  token = var.github_token
}

provider "github" {
  owner = "songmatrix"
  alias = "songmatrix"
  token = var.github_token
}
