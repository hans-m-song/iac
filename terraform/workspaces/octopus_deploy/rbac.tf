resource "octopusdeploy_user" "worker" {
  display_name = "worker"
  username     = "worker"
  is_service   = true
  is_active    = true
}

resource "octopusdeploy_team" "workers" {
  name  = "Workers"
  users = [octopusdeploy_user.worker.id]
}

resource "octopusdeploy_scoped_user_role" "build_server_workers_assignment" {
  space_id     = local.space_id
  team_id      = octopusdeploy_team.workers.id
  user_role_id = "userroles-buildserver"
}

resource "octopusdeploy_user_role" "worker_registrator" {
  name                       = "Worker registrator"
  description                = "Worker registrators can assign themselves to a worker pool"
  granted_space_permissions  = ["WorkerView", "MachinePolicyView", "WorkerEdit"]
  granted_system_permissions = []
}

resource "octopusdeploy_scoped_user_role" "worker_registrator_workers_assignment" {
  space_id     = local.space_id
  team_id      = octopusdeploy_team.workers.id
  user_role_id = octopusdeploy_user_role.worker_registrator.id
}

resource "octopusdeploy_user" "executor" {
  display_name = "executor"
  username     = "executor"
  is_service   = true
  is_active    = true
}

resource "octopusdeploy_team" "executors" {
  name  = "Executors"
  users = [octopusdeploy_user.executor.id]
}

resource "octopusdeploy_scoped_user_role" "package_publisher_executors_assignment" {
  space_id     = local.space_id
  team_id      = octopusdeploy_team.executors.id
  user_role_id = "userroles-packagepublisher"
}

resource "octopusdeploy_user_role" "limited_project_deployer" {
  name                       = "Limited project deployer"
  description                = "Limited project deployers can create and deploy project releases"
  granted_space_permissions  = ["EnvironmentView", "DeploymentCreate", "DeploymentView", "ProjectView", "ReleaseCreate", "ReleaseView", "TaskView", "TenantView"]
  granted_system_permissions = []
}

resource "octopusdeploy_scoped_user_role" "limited_project_deployer_executors_assignment" {
  space_id     = local.space_id
  team_id      = octopusdeploy_team.executors.id
  user_role_id = octopusdeploy_user_role.limited_project_deployer.id
}
