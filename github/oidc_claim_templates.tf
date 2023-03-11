resource "github_actions_repository_oidc_subject_claim_customization_template" "axatol" {
  for_each = toset(local.github_repositories_axatol)

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

resource "github_actions_repository_oidc_subject_claim_customization_template" "hans_m_song" {
  for_each = toset(local.github_repositories_hans_m_song)

  provider    = github.hans_m_song
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
  for_each = toset(local.github_repositories_songmatrix)

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
