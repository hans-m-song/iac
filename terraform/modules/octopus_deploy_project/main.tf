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

resource "octopusdeploy_deployment_process" "this" {
  project_id = octopusdeploy_project.this.id

  dynamic "step" {
    for_each = local.cdk_deployment
    content {
      name = "Deploy CDK App"

      run_script_action {
        name          = "Deploy Kubernetes Manifests"
        run_on_server = true
        sort_order    = 1
        tenant_tags   = step.value.tenant_tags

        package {
          name       = "package"
          feed_id    = coalesce(step.value.feed_id, data.octopusdeploy_feeds.built_in.feeds[0].id)
          package_id = step.value.package_id
        }
      }
    }
  }

  dynamic "step" {
    for_each = local.helm_deployment
    content {
      name         = "Deploy Helm Chart"
      target_roles = step.value.target_roles

      run_kubectl_script_action {
        name          = "Render Helm Chart"
        run_on_server = true
        sort_order    = 1
        tenant_tags   = step.value.tenant_tags

        package {
          name                 = "chart"
          feed_id              = coalesce(step.value.feed_id, data.octopusdeploy_feeds.built_in.feeds[0].id)
          package_id           = step.value.chart_name
          acquisition_location = "ExecutionTarget"
        }

        package {
          name                 = "image"
          feed_id              = coalesce(step.value.feed_id, data.octopusdeploy_feeds.built_in.feeds[0].id)
          package_id           = step.value.chart_name
          acquisition_location = "ExecutionTarget"
        }

        script_syntax = "Bash"
        script_body   = <<-EOT
          set -eo pipefail
          chart_path=$(get_octopusvariable "Octopus.Action.Package[chart].ExtractedPath")
          chart_name=$(get_octopusvariable "Helm.ChartName")
          namespace=$(get_octopusvariable "Helm.Namespace")
          release_name=$(get_octopusvariable "Helm.ReleaseName")
          image_repository=$(get_octopusvariable "Octopus.Action.Package[chart].Url")
          image_version=$(get_octopusvariable "Octopus.Action.Package[chart].PackageVersion")

          echo "chart path:       $chart_path"
          echo "chart name:       $chart_name"
          echo "namespace:        $namespace"
          echo "release name:     $release_name"
          echo "image repository: $image_repository"
          echo "image version:    $image_version"

          helm template $release_name $package_path/$chart_name \
            --namespace $namespace \
            --set image.repository=$image_repository \
            --set image.tag=$image_version \
            > template.yaml
          set_octopusvariable "Template" "$(cat template.yaml)"
          new_octopusartifact template.yaml
        EOT
      }

      action {
        name          = "Apply Helm Chart Template"
        action_type   = "Octopus.KubernetesDeployRawYaml"
        run_on_server = true
        sort_order    = 2
        tenant_tags   = step.value.tenant_tags

        properties = {
          "Octopus.Action.Kubernetes.DeploymentTimeout"            = "300"
          "Octopus.Action.Kubernetes.ResourceStatusCheck"          = "True"
          "Octopus.Action.Kubernetes.WaitForJobs"                  = "True"
          "Octopus.Action.KubernetesContainers.CustomResourceYaml" = "#{Octopus.Action[Render Helm Chart].Outputs.Template}"
          "Octopus.Action.KubernetesContainers.Namespace"          = "#{Helm.Namespace}"
          "Octopus.Action.RunOnServer"                             = "True"
          "Octopus.Action.Script.ScriptSource"                     = "Inline"
        }
      }
    }
  }
}

data "http" "project_versioning_strategy" {
  url        = "${var.server_url}/api/${octopusdeploy_project.this.space_id}/projects/${octopusdeploy_project.this.id}"
  method     = "PUT"
  depends_on = [octopusdeploy_project.this]
  request_headers = {
    "name" = "value"
  }

  request_body = jsonencode({
    SpaceId        = octopusdeploy_project.this.space_id
    Name           = octopusdeploy_project.this.name
    ProjectGroupId = octopusdeploy_project.this.project_group_id
    ProjectId      = octopusdeploy_project.this.id
    LifecycleId    = octopusdeploy_project.this.lifecycle_id
    VersioningStrategy = {
      Template = "#{Octopus.Date.Year}.#{Octopus.Date.Month}.#{Octopus.Version.NextPatch}"
    }
  })

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to set versioning strategy: ${self.status_code} - ${self.response_body}"
    }
  }
}
