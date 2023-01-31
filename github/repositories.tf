resource "github_repository" "axatol_actions" {
  provider = github.axatol
  name     = "actions"

  has_issues      = true
  has_discussions = false
  has_projects    = true
  has_wiki        = true
  has_downloads   = false

  allow_merge_commit  = true
  allow_rebase_merge  = false
  allow_squash_merge  = false
  allow_auto_merge    = true
  allow_update_branch = true

  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"

  merge_commit_title   = "MERGE_MESSAGE"
  merge_commit_message = "PR_TITLE"

  delete_branch_on_merge = true

  topics = [
    "actions",
    "github",
  ]
}

resource "github_repository" "axatol_home-assistant-integrations" {
  provider    = github.axatol
  name        = "home-assistant-integrations"
  description = "Home Assistant custom integrations"

  has_issues      = true
  has_discussions = false
  has_projects    = true
  has_wiki        = true
  has_downloads   = false

  allow_merge_commit  = true
  allow_rebase_merge  = false
  allow_squash_merge  = false
  allow_auto_merge    = true
  allow_update_branch = true

  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"

  merge_commit_title   = "MERGE_MESSAGE"
  merge_commit_message = "PR_TITLE"

  delete_branch_on_merge = true

  topics = [
    "docker",
    "home-assistant",
    "kubernetes",
    "mqtt",
    "zeversolar",
  ]
}

resource "github_repository" "hans-m-song_huisheng" {
  provider    = github.hans-m-song
  name        = "huisheng"
  description = "Quick and dirty Discord bot with Youtube support"

  has_issues      = true
  has_discussions = false
  has_projects    = true
  has_wiki        = true
  has_downloads   = false

  allow_merge_commit  = true
  allow_rebase_merge  = false
  allow_squash_merge  = false
  allow_auto_merge    = true
  allow_update_branch = true

  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"

  merge_commit_title   = "MERGE_MESSAGE"
  merge_commit_message = "PR_TITLE"

  delete_branch_on_merge = true

  topics = [
    "discord",
    "discord-bot",
    "discord-js",
    "typescript",
  ]
}

resource "github_repository" "hans-m-song_kube-stack" {
  provider    = github.hans-m-song
  name        = "kube-stack"
  description = "Bare metal k3s config"

  has_issues      = true
  has_discussions = false
  has_projects    = true
  has_wiki        = true
  has_downloads   = false

  allow_merge_commit  = true
  allow_rebase_merge  = false
  allow_squash_merge  = false
  allow_auto_merge    = true
  allow_update_branch = true

  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"

  merge_commit_title   = "MERGE_MESSAGE"
  merge_commit_message = "PR_TITLE"

  delete_branch_on_merge = true

  topics = [
    "cdk8s",
    "k3s",
    "kubernetes",
  ]
}

resource "github_repository" "hans-m-song_iac" {
  provider = github.hans-m-song
  name     = "iac"

  has_issues      = true
  has_discussions = false
  has_projects    = true
  has_wiki        = true
  has_downloads   = false

  allow_merge_commit  = true
  allow_rebase_merge  = false
  allow_squash_merge  = false
  allow_auto_merge    = true
  allow_update_branch = true

  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"

  merge_commit_title   = "MERGE_MESSAGE"
  merge_commit_message = "PR_TITLE"

  delete_branch_on_merge = true
}

resource "github_repository" "songmatrix_data-service" {
  provider = github.songmatrix
  name     = "data-service"

  has_issues      = true
  has_discussions = false
  has_projects    = true
  has_wiki        = true
  has_downloads   = false

  allow_merge_commit  = true
  allow_rebase_merge  = false
  allow_squash_merge  = false
  allow_auto_merge    = true
  allow_update_branch = true

  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"

  merge_commit_title   = "MERGE_MESSAGE"
  merge_commit_message = "PR_TITLE"

  delete_branch_on_merge = true
}

resource "github_repository" "songmatrix_frontend-web" {
  provider = github.songmatrix
  name     = "frontend-web"

  has_issues      = true
  has_discussions = false
  has_projects    = true
  has_wiki        = true
  has_downloads   = false

  allow_merge_commit  = true
  allow_rebase_merge  = false
  allow_squash_merge  = false
  allow_auto_merge    = true
  allow_update_branch = true

  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"

  merge_commit_title   = "MERGE_MESSAGE"
  merge_commit_message = "PR_TITLE"

  delete_branch_on_merge = true
}

resource "github_repository" "songmatrix_gateway" {
  provider = github.songmatrix
  name     = "gateway"

  has_issues      = true
  has_discussions = false
  has_projects    = true
  has_wiki        = true
  has_downloads   = false

  allow_merge_commit  = true
  allow_rebase_merge  = false
  allow_squash_merge  = false
  allow_auto_merge    = true
  allow_update_branch = true

  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"

  merge_commit_title   = "MERGE_MESSAGE"
  merge_commit_message = "PR_TITLE"

  delete_branch_on_merge = true
}

resource "github_repository" "songmatrix_github" {
  provider = github.songmatrix
  name     = ".github"

  has_issues      = true
  has_discussions = false
  has_projects    = true
  has_wiki        = true
  has_downloads   = false

  allow_merge_commit  = true
  allow_rebase_merge  = false
  allow_squash_merge  = false
  allow_auto_merge    = true
  allow_update_branch = true

  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"

  merge_commit_title   = "MERGE_MESSAGE"
  merge_commit_message = "PR_TITLE"

  delete_branch_on_merge = true
}

resource "github_repository" "songmatrix_sync-service" {
  provider = github.songmatrix
  name     = "sync-service"

  has_issues      = true
  has_discussions = false
  has_projects    = true
  has_wiki        = true
  has_downloads   = false

  allow_merge_commit  = true
  allow_rebase_merge  = false
  allow_squash_merge  = false
  allow_auto_merge    = true
  allow_update_branch = true

  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"

  merge_commit_title   = "MERGE_MESSAGE"
  merge_commit_message = "PR_TITLE"

  delete_branch_on_merge = true
}
