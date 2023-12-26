locals {
  od_space_id          = "Spaces-1"
  od_role_aws_use1     = "aws/us-east-1"
  od_role_aws_apse2    = "aws/ap-southeast-2"
  od_role_k8s_wheatley = "k8s/wheatley"
}

# library

resource "octopusdeploy_docker_container_registry" "dockerhub" {
  name     = "DockerHub - axatol"
  feed_uri = "https://index.docker.io"
  username = var.octopus_deploy_dockerhub_username
  password = var.octopus_deploy_dockerhub_access_token
}

resource "octopusdeploy_github_repository_feed" "github" {
  name     = "GitHub"
  feed_uri = "https://api.github.com"
  password = var.octopus_deploy_github_token
}

resource "octopusdeploy_helm_feed" "huisheng" {
  name     = "Helm - Huisheng"
  feed_uri = "https://huisheng.charts.axatol.xyz"
}

resource "octopusdeploy_environment" "development" {
  name       = "Development"
  sort_order = 0
}

resource "octopusdeploy_environment" "production" {
  name       = "Production"
  sort_order = 1
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

# tenants

resource "octopusdeploy_tag_set" "regions" {
  name = "regions"
}

resource "octopusdeploy_tag" "region_apse2" {
  name       = "ap-southeast-2"
  tag_set_id = octopusdeploy_tag_set.regions.id
  color      = "#FF9900"
}

resource "octopusdeploy_tag" "region_use1" {
  name       = "us-east-1"
  tag_set_id = octopusdeploy_tag_set.regions.id
  color      = "#FF9900"
}

resource "octopusdeploy_tag_set" "clusters" {
  name = "clusters"
}

resource "octopusdeploy_tag" "cluster_wheatley" {
  name       = "wheatley"
  tag_set_id = octopusdeploy_tag_set.clusters.id
  color      = "#3970E4"
}

resource "octopusdeploy_tenant" "apse2" {
  name        = "ap-southeast-2"
  tenant_tags = [octopusdeploy_tag.region_apse2.canonical_tag_name]
}

resource "octopusdeploy_tenant" "use1" {
  name        = "us-east-1"
  tenant_tags = [octopusdeploy_tag.region_use1.canonical_tag_name]
}

resource "octopusdeploy_tenant" "wheatley" {
  name        = "wheatley"
  tenant_tags = [octopusdeploy_tag.cluster_wheatley.canonical_tag_name]
}

# infrastructure

resource "octopusdeploy_static_worker_pool" "octopi" {
  name = "Octopi"
}

resource "octopusdeploy_cloud_region_deployment_target" "apse2" {
  name         = "ap-southeast-2"
  roles        = [local.od_role_aws_apse2]
  environments = [octopusdeploy_environment.development.id, octopusdeploy_environment.production.id]
  tenant_tags  = [octopusdeploy_tag.region_apse2.canonical_tag_name]
}

resource "octopusdeploy_cloud_region_deployment_target" "use1" {
  name         = "us-east-1"
  roles        = [local.od_role_aws_use1]
  environments = [octopusdeploy_environment.development.id, octopusdeploy_environment.production.id]
  tenant_tags  = [octopusdeploy_tag.region_use1.canonical_tag_name]
}

resource "octopusdeploy_kubernetes_cluster_deployment_target" "wheatley" {
  name         = "wheatley"
  cluster_url  = "https://kubernetes.default.svc.cluster.local"
  roles        = [local.od_role_k8s_wheatley]
  environments = [octopusdeploy_environment.development.id, octopusdeploy_environment.production.id]
  tenant_tags  = [octopusdeploy_tag.cluster_wheatley.canonical_tag_name]

  endpoint {
    communication_style = "Kubernetes"
    cluster_url         = "https://kubernetes.default.svc.cluster.local"
  }

  pod_authentication {
    token_path = "/var/run/secrets/kubernetes.io/serviceaccount/token"
  }
}

# rbac

resource "octopusdeploy_user_role" "deployer" {
  name        = "Deployer"
  description = "Role to publish packages, create releases, and create deployments"

  granted_space_permissions = [
    "BuildInformationPush",
    "BuiltInFeedPush",
    "DeploymentCreate",
    "DeploymentView",
    "EnvironmentView",
    "FeedView",
    "LifecycleView",
    "ProjectView",
    "ReleaseCreate",
    "ReleaseView",
    "TaskView",
    "TenantView",
    "ProcessView",
  ]
}

resource "octopusdeploy_user" "squidward" {
  username     = "squidward"
  display_name = "Squidward"
  is_active    = true
  is_service   = true
}

resource "octopusdeploy_team" "deployer" {
  name  = "Deployer"
  users = [octopusdeploy_user.squidward.id]

  user_role {
    space_id     = local.od_space_id
    user_role_id = octopusdeploy_user_role.deployer.id
  }
}

resource "octopusdeploy_user_role" "tentacle" {
  name        = "Tentacle"
  description = "Worker registration role"

  granted_space_permissions = [
    "WorkerView",
    "MachinePolicyView",
    "ProjectView",
    "WorkerEdit",
  ]
}

resource "octopusdeploy_user" "octodad" {
  username     = "octodad"
  display_name = "Octodad"
  is_active    = true
  is_service   = true
}

resource "octopusdeploy_team" "tentacles" {
  name  = "Tentacles"
  users = [octopusdeploy_user.octodad.id]

  user_role {
    space_id     = local.od_space_id
    user_role_id = octopusdeploy_user_role.tentacle.id
  }
}

# projects

resource "octopusdeploy_project_group" "kubernetes" {
  name = "Kubernetes"
}
