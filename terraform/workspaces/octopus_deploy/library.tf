resource "octopusdeploy_docker_container_registry" "dockerhub" {
  name     = "DockerHub - axatol"
  feed_uri = "https://index.docker.io"
  username = var.dockerhub_username
  password = var.dockerhub_access_token
}

resource "octopusdeploy_github_repository_feed" "github" {
  name     = "GitHub"
  feed_uri = "https://api.github.com"
  password = var.github_token
}

data "octopusdeploy_feeds" "built_in" {
  ids  = ["feeds-builtin"]
  skip = 0
  take = 1
}

resource "octopusdeploy_helm_feed" "huisheng" {
  name     = "Helm - Huisheng"
  feed_uri = "https://huisheng.charts.axatol.xyz"
}

resource "octopusdeploy_environment" "development" {
  name       = "Development"
  sort_order = 1
}

resource "octopusdeploy_environment" "production" {
  name       = "Production"
  sort_order = 2
}

resource "octopusdeploy_lifecycle" "standard" {
  name = "Standard"

  release_retention_policy {
    quantity_to_keep = 1
    unit             = "Items"
  }

  tentacle_retention_policy {
    quantity_to_keep = 1
    unit             = "Items"
  }

  phase {
    name                                  = "Development"
    minimum_environments_before_promotion = 1
    is_optional_phase                     = false
    optional_deployment_targets           = [octopusdeploy_environment.development.id]
  }

  phase {
    name                                  = "Production"
    minimum_environments_before_promotion = 1
    is_optional_phase                     = false
    optional_deployment_targets           = [octopusdeploy_environment.production.id]
  }
}

resource "octopusdeploy_lifecycle" "production_only" {
  name = "Production only"

  release_retention_policy {
    quantity_to_keep = 1
    unit             = "Items"
  }

  tentacle_retention_policy {
    quantity_to_keep = 1
    unit             = "Items"
  }

  phase {
    name                         = "Production"
    automatic_deployment_targets = [octopusdeploy_environment.production.id]
  }
}
