resource "github_actions_repository_oidc_subject_claim_customization_template" "hans-m-song_iac" {
  provider   = github.hans-m-song
  repository = github_repository.hans-m-song_iac.name

  use_default = false

  include_claim_keys = [
    "repo",
    "context",
    "workflow",
    "job_workflow_ref",
    "actor",
  ]
}
