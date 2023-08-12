locals {
  octopusdeploy_space_id = "Spaces-1"
}

# environments

resource "octopusdeploy_environment" "development" {
  name       = "Development"
  sort_order = 0
}

resource "octopusdeploy_environment" "production" {
  name       = "Production"
  sort_order = 1
}

# tenants

resource "octopusdeploy_tenant" "aws_ap_southeast_1" {
  name = "AWS - Singapore (ap-southeast-1)"
}

resource "octopusdeploy_tenant" "aws_ap_southeast_2" {
  name = "AWS - Sydney (ap-southeast-2)"
}

resource "octopusdeploy_tenant" "aws_us_east_1" {
  name = "AWS - North Virginia (us-east-1)"
}

resource "octopusdeploy_tenant" "k8s_wheatley" {
  name = "K8S - Wheatley"
}

# worker pools

resource "octopusdeploy_static_worker_pool" "octopi" {
  name = "Octopi"
}

# rbac

resource "octopusdeploy_user_role" "tentacle" {
  name = "Tentacle"

  granted_space_permissions = [
    "WorkerView",
    "MachinePolicyView",
    "ProjectView",
    "WorkerEdit",

    # EnvironmentEdit
    # EnvironmentView
    # MachineCreate
    # MachineEdit
    # MachinePolicyView
    # MachineView
  ]
}

resource "octopusdeploy_user" "octodad" {
  username     = "octodad"
  display_name = "Octodad"
  is_active    = true
  is_service   = true
}

resource "octopusdeploy_team" "tentacles" {
  name = "Tentacles"

  users = [
    octopusdeploy_user.octodad.id,
  ]

  user_role {
    space_id     = local.octopusdeploy_space_id
    user_role_id = octopusdeploy_user_role.tentacle.id
  }
}

# resource "octopusdeploy_listening_tentacle_deployment_target" "name" {
#   environments = ["value"]
#   name         = "value"
#   roles        = ["value"]
#   tentacle_url = "value"
#   thumbprint   = "value"
# }
