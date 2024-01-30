locals {
  cdk_deployment        = var.cdk_deployment != null ? [var.cdk_deployment] : []
  helm_deployment       = var.helm_deployment != null ? [var.helm_deployment] : []
  kubernetes_deployment = var.kubernetes_deployment != null ? [var.kubernetes_deployment] : []
}

resource "octopusdeploy_project" "this" {
  name             = var.name
  description      = var.description
  lifecycle_id     = var.lifecycle_id
  project_group_id = var.project_group_id
}

resource "octopusdeploy_variable" "container_options" {
  owner_id = octopusdeploy_project.this.id
  name     = "Octopus.Action.Container.Options"
  type     = "String"
  value = join(" ", [
    "--volume",
    "/var/run/secrets/kubernetes.io/serviceaccount:/var/run/secrets/kubernetes.io/serviceaccount",
  ])
}

resource "octopusdeploy_variable" "cdk_app_name" {
  owner_id = octopusdeploy_project.this.id
  name     = "CDK.AppName"
  type     = "String"
  value    = "value"
}

resource "octopusdeploy_variable" "helm_namespace" {
  owner_id = octopusdeploy_project.this.id
  name     = "Helm.Namespace"
  type     = "String"
  value    = "value"
}

resource "octopusdeploy_variable" "helm_chart_name" {
  owner_id = octopusdeploy_project.this.id
  name     = "Helm.ChartName"
  type     = "String"
  value    = "value"
}

resource "octopusdeploy_variable" "helm_release_name" {
  owner_id = octopusdeploy_project.this.id
  name     = "Helm.ReleaseName"
  type     = "String"
  value    = "value"
}

resource "octopusdeploy_variable" "kubernetes_manifests" {
  owner_id = octopusdeploy_project.this.id
  name     = "Kubernetes.Manifests"
  type     = "String"
  value    = "value"
}

resource "octopusdeploy_deployment_process" "this" {
  project_id = octopusdeploy_project.this.id

  dynamic "step" {
    for_each = local.cdk_deployment
    content {
      name = "Deploy CDK App"

      run_script_action {
        name = "Deploy Kubernetes Manifests"
      }
    }
  }

  dynamic "step" {
    for_each = local.helm_deployment
    content {
      name         = "Deploy Helm Chart"
      target_roles = step.value.target_roles

      run_kubectl_script_action {
        name          = "Deploy Helm Chart"
        run_on_server = true
        sort_order    = 1
        tenant_tags   = step.value.tenant_tags

        package {
          name       = "package"
          feed_id    = coalesce(step.value.feed_id, data.octopusdeploy_feeds.built_in.feeds[0].id)
          package_id = step.value.chart_name
        }

        script_syntax = "Bash"
        script_body   = <<-EOT
          set -eo pipefail
          package_path=$(get_octopusvariable "Octopus.Action.Package[package].ExtractedPath")
          namespace=$(get_octopusvariable "Helm.Namespace")
          chart_name=$(get_octopusvariable "Helm.ChartName")
          release_name=$(get_octopusvariable "Helm.ReleaseName")
          helm deploy $release_name $package_path/$chart_name --namespace $namespace
        EOT
      }

      # run_kubectl_script_action {
      #   name          = "Apply Chart"
      #   run_on_server = true
      #   sort_order    = 2
      #   tenant_tags   = var.helm_deployment.tenant_tags

      #   primary_package {
      #     feed_id    = coalesce(var.helm_deployment.feed_id, local.default_feed_id)
      #     package_id = var.helm_deployment.chart_name
      #   }

      #   script_syntax = "Bash"
      #   script_body   = <<-EOT
      #     set -eo pipefail
      #               package_path=$(get_octopusvariable "Octopus.Action.Package[package].ExtractedPath")
      #     namespace=$(get_octopusvariable "Helm.Namespace")
      #     chart_name=$(get_octopusvariable "Helm.ChartName")
      #     release_name=$(get_octopusvariable "Helm.ReleaseName")
      #     helm deploy $release_name $package_path/$chart_name --namespace $namespace

      #   EOT
      # }
    }
  }

  # dynamic "step" {
  #   for_each = local.kubernetes_deployment
  #   content {
  #     name = "Deploy Kubernetes Manifests"

  #     run_kubectl_script_action {
  #       name = "Deploy Kubernetes Manifests"
  #     }

  #     run_kubectl_script_action {
  #       name = "Rollout deployments"
  #     }
  #   }
  # }
}
