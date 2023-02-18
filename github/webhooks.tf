resource "github_organization_webhook" "actions_runner_controller_axatol" {
  provider = github.axatol

  configuration {
    content_type = "json"
    insecure_ssl = false
    url          = var.github_arc_webhook_url
  }

  events = ["workflow_job"]
  active = true
}

resource "github_organization_webhook" "actions_runner_controller_songmatrix" {
  provider = github.songmatrix

  configuration {
    content_type = "json"
    insecure_ssl = false
    url          = var.github_arc_webhook_url
  }

  events = ["workflow_job"]
  active = true
}

resource "github_repository_webhook" "actions_runner_controller_hans-m-song" {
  for_each = toset(local.github_repositories_hans-m-song)

  provider   = github.hans-m-song
  repository = each.value

  configuration {
    content_type = "json"
    insecure_ssl = false
    url          = var.github_arc_webhook_url
  }

  events = ["workflow_job"]
  active = true
}
