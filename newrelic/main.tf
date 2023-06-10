terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "axatol"

    workspaces {
      name = "newrelic"
    }
  }

  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.24.0"
    }
  }
}

provider "newrelic" {
  account_id = var.newrelic_account_id
  api_key    = var.newrelic_api_key
}
