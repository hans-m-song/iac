resource "github_repository_webhook" "actions_runner_controller_hans-m-song-huisheng" {
  provider   = github.hans-m-song
  repository = "huisheng"

  configuration {
    content_type = "json"
    insecure_ssl = false
    url          = var.github_arc_webhook_url
  }

  events = ["workflow_job"]
  active = true
}

resource "github_repository_webhook" "actions_runner_controller_hans-m-song-iac" {
  provider   = github.hans-m-song
  repository = "iac"

  configuration {
    content_type = "json"
    insecure_ssl = false
    url          = var.github_arc_webhook_url
  }

  events = ["workflow_job"]
  active = true
}

resource "github_repository_webhook" "actions_runner_controller_hans-m-song-kube-stack" {
  provider   = github.hans-m-song
  repository = "kube-stack"

  configuration {
    content_type = "json"
    insecure_ssl = false
    url          = var.github_arc_webhook_url
  }

  events = ["workflow_job"]
  active = true
}


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
