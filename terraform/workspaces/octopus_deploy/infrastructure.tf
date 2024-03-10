resource "octopusdeploy_static_worker_pool" "octopi" {
  name       = "Octopi"
  is_default = true
}

resource "octopusdeploy_cloud_region_deployment_target" "apse2" {
  name                              = "ap-southeast-2"
  roles                             = [local.aws_apse2_role]
  environments                      = [octopusdeploy_environment.production.id, octopusdeploy_environment.development.id]
  tenant_tags                       = [octopusdeploy_tag.region_apse2.canonical_tag_name]
  tenants                           = [octopusdeploy_tenant.apse2.id]
  tenanted_deployment_participation = "TenantedOrUntenanted"
  default_worker_pool_id            = octopusdeploy_static_worker_pool.octopi.id
}

resource "octopusdeploy_cloud_region_deployment_target" "use1" {
  name                              = "us-east-1"
  roles                             = [local.aws_use1_role]
  environments                      = [octopusdeploy_environment.production.id, octopusdeploy_environment.development.id]
  tenant_tags                       = [octopusdeploy_tag.region_use1.canonical_tag_name]
  tenants                           = [octopusdeploy_tenant.use1.id]
  tenanted_deployment_participation = "TenantedOrUntenanted"
  default_worker_pool_id            = octopusdeploy_static_worker_pool.octopi.id
}

resource "octopusdeploy_kubernetes_cluster_deployment_target" "wheatley" {
  name                              = "wheatley"
  cluster_url                       = "https://kubernetes.default.svc.cluster.local"
  roles                             = [local.k8s_wheatley_role]
  environments                      = [octopusdeploy_environment.production.id, octopusdeploy_environment.development.id]
  tenant_tags                       = [octopusdeploy_tag.cluster_wheatley.canonical_tag_name]
  tenants                           = [octopusdeploy_tenant.wheatley.id]
  tenanted_deployment_participation = "TenantedOrUntenanted"
  default_worker_pool_id            = octopusdeploy_static_worker_pool.octopi.id
  cluster_certificate_path          = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"

  endpoint {
    communication_style      = "Kubernetes"
    cluster_url              = "https://kubernetes.default.svc.cluster.local"
    cluster_certificate_path = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
    default_worker_pool_id   = octopusdeploy_static_worker_pool.octopi.id
  }

  pod_authentication {
    token_path = "/var/run/secrets/kubernetes.io/serviceaccount/token"
  }
}
