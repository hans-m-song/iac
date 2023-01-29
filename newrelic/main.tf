terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "deep-thought"

    workspaces {
      prefix = "iac-newrelic"
    }
  }

  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.13.0"
    }
  }
}

provider "newrelic" {}
