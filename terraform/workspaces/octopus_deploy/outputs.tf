output "kubernetes_project_group_id" {
  value = octopusdeploy_project_group.kubernetes.id
}

output "development_environment_id" {
  value = octopusdeploy_environment.development.id
}
output "production_environment_id" {
  value = octopusdeploy_environment.production.id
}

output "standard_octopusdeploy_lifecycle_id" {
  value = octopusdeploy_lifecycle.standard.id
}

output "production_only_lifecycle_id" {
  value = octopusdeploy_lifecycle.production_only.id
}

output "built_in_feed_id" {
  value = data.octopusdeploy_feeds.built_in.feeds[0].id
}

output "executor_user_id" {
  value = octopusdeploy_user.executor.id
}

output "apse2_tenant_id" {
  value = octopusdeploy_tenant.apse2.id
}

output "use1_tenant_id" {
  value = octopusdeploy_tenant.use1.id
}

output "wheatley_tenant_id" {
  value = octopusdeploy_tenant.wheatley.id
}
