resource "octopusdeploy_team" "workers" {
  name = "Workers"
}

resource "octopusdeploy_scoped_user_role" "build_server_workers_assignment" {
  space_id     = local.space_id
  team_id      = octopusdeploy_team.workers.id
  user_role_id = "userroles-buildserver"
}

resource "octopusdeploy_user_role" "worker_registrator" {
  name                       = "Worker Registrator"
  granted_space_permissions  = ["WorkerView", "MachinePolicyView", "WorkerEdit"]
  granted_system_permissions = []
}

resource "octopusdeploy_scoped_user_role" "worker_registrator_workers_assignment" {
  space_id     = local.space_id
  team_id      = octopusdeploy_team.workers.id
  user_role_id = octopusdeploy_user_role.worker_registrator.id
}
