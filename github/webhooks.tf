resource "github_repository_webhook" "actions_runner_controller_hans-m-song_blog" {
  provider   = github.hans-m-song
  repository = github_repository.hans-m-song_blog.name

  configuration {
    content_type = "json"
    insecure_ssl = false
    url          = var.github_arc_webhook_url
  }

  events = ["workflow_job"]
  active = true
}

resource "github_repository_webhook" "actions_runner_controller_hans-m-song-huisheng" {
  provider   = github.hans-m-song
  repository = github_repository.hans-m-song_huisheng.name

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
  repository = github_repository.hans-m-song_iac.name

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
  repository = github_repository.hans-m-song_kube-stack.name

  configuration {
    content_type = "json"
    insecure_ssl = false
    url          = var.github_arc_webhook_url
  }

  events = ["workflow_job"]
  active = true
}

resource "github_repository_webhook" "actions_runner_controller_hans-m-song-saml2aws" {
  provider   = github.hans-m-song
  repository = github_repository.hans-m-song_saml2aws.name

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
