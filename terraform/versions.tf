terraform {
  backend "s3" {
    region         = "ap-southeast-2"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform-state-lock"
  }

  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "1.0.0-beta.4"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 5.37.0"
    }

    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.26.0"
    }

    octopusdeploy = {
      source  = "OctopusDeployLabs/octopusdeploy"
      version = "~> 0.12.7"
    }
  }
}
