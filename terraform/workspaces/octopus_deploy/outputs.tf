output "kubernetes_project_group_id" {
  value = octopusdeploy_project_group.kubernetes.id
}

output "production_only_lifecycle_id" {
  value = octopusdeploy_lifecycle.production_only.id
}

output "built_in_feed_id" {
  value = data.octopusdeploy_feeds.built_in.feeds[0].id
}
