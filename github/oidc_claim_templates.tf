resource "github_actions_repository_oidc_subject_claim_customization_template" "axatol" {
  for_each = toset([
    github_repository.axatol_home-assistant-integrations.name,
  ])

  provider    = github.axatol
  repository  = each.value
  use_default = false
  include_claim_keys = [
    "repo",
    "context",
    "workflow",
    "job_workflow_ref",
    "actor",
  ]
}

resource "github_actions_repository_oidc_subject_claim_customization_template" "hans-m-song" {
  for_each = toset([
    github_repository.hans-m-song_iac.name,
    github_repository.hans-m-song_kube-stack.name,
    github_repository.hans-m-song_huisheng.name,
  ])

  provider    = github.hans-m-song
  repository  = each.value
  use_default = false
  include_claim_keys = [
    "repo",
    "context",
    "workflow",
    "job_workflow_ref",
    "actor",
  ]
}

resource "github_actions_repository_oidc_subject_claim_customization_template" "songmatrix" {
  for_each = toset([
    github_repository.songmatrix_data-service.name,
    github_repository.songmatrix_gateway.name,
    github_repository.songmatrix_sync-service.name,
  ])

  provider    = github.songmatrix
  repository  = each.value
  use_default = false
  include_claim_keys = [
    "repo",
    "context",
    "workflow",
    "job_workflow_ref",
    "actor",
  ]
}
