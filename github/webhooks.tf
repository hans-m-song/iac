resource "github_organization_webhook" "actions_runner_controller-axatol" {
  provider = github.axatol

  configuration {
    content_type = "json"
    insecure_ssl = false
    url          = var.github_arc_webhook_url
  }

  events = ["workflow_job"]
  active = true
}

resource "github_organization_webhook" "actions_runner_controller-songmatrix" {
  provider = github.songmatrix

  configuration {
    content_type = "json"
    insecure_ssl = false
    url          = var.github_arc_webhook_url
  }

  events = ["workflow_job"]
  active = true
}

resource "github_repository_webhook" "actions_runner_controller-hans_m_song" {
  for_each = toset(local.github_repositories_hans_m_song)

  provider   = github.hans_m_song
  repository = each.value

  configuration {
    content_type = "json"
    insecure_ssl = false
    url          = var.github_arc_webhook_url
  }

  events = ["workflow_job"]
  active = true
}

resource "github_repository_webhook" "new_relic-hans_m_song" {
  for_each = toset(local.github_repositories_hans_m_song)

  provider   = github.hans_m_song
  repository = each.value

  configuration {
    content_type = "json"
    insecure_ssl = false
    url          = "https://log-api.newrelic.com/log/v1?Api-Key=${var.new_relic_license_key}"
  }

  events = ["workflow_job"]
  active = true
}
