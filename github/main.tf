terraform {
  backend "remote" {
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
  token = var.github_token
}
