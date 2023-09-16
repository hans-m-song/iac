resource "octopusdeploy_deployment_process" "this" {
  project_id = var.project_id

  step {
    name         = "Upgrade a Helm Chart"
    target_roles = var.target_roles

    action {
      name           = "Upgrade a Helm Chart"
      action_type    = "Octopus.HelmChartUpgrade"
      run_on_server  = true
      is_required    = true
      sort_order     = 1
      worker_pool_id = var.worker_pool_id
      tenant_tags    = var.tenant_tags

      primary_package {
        feed_id              = var.feed_id
        package_id           = var.package_id
        acquisition_location = "ExecutionTarget"
      }

      properties = {
        "Octopus.Action.Helm.ClientVersion"         = "V3"
        "Octopus.Action.Helm.KeyValues"             = jsonencode(var.release_values)
        "Octopus.Action.Helm.Namespace"             = var.release_namespace
        "Octopus.Action.Helm.ResetValues"           = "True"
        "Octopus.Action.Package.DownloadOnTentacle" = "False"
        "OctopusUseBundledTooling"                  = "False"
      }
    }
  }
}
