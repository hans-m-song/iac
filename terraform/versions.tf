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

    zerotier = {
      source  = "zerotier/zerotier"
      version = "1.4.2"
    }
  }
}
