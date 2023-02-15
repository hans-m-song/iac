resource "github_repository" "axatol_actions" {
  provider = github.axatol
  name     = "actions"

  allow_auto_merge       = true
  allow_update_branch    = true
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

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true

  topics = [
    "docker",
    "home-assistant",
    "kubernetes",
    "mqtt",
    "zeversolar",
  ]
}

resource "github_repository" "axatol_youtube-dl" {
  provider    = github.axatol
  name        = "youtube-dl"
  description = "Youtube downloader server and frontend"


  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "hans-m-song_blog" {
  provider     = github.hans-m-song
  name         = "blog"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "hans-m-song_huisheng" {
  provider    = github.hans-m-song
  name        = "huisheng"
  description = "Quick and dirty Discord bot with Youtube support"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true

  topics = [
    "discord",
    "discord-bot",
    "discord-js",
    "typescript",
  ]
}

resource "github_repository" "hans-m-song_iac" {
  provider = github.hans-m-song
  name     = "iac"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "hans-m-song_kube-stack" {
  provider    = github.hans-m-song
  name        = "kube-stack"
  description = "Bare metal k3s config"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true

  topics = [
    "cdk8s",
    "k3s",
    "kubernetes",
  ]
}

resource "github_repository" "hans-m-song_saml2aws" {
  provider     = github.hans-m-song
  name         = "saml2aws"
  description  = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP"
  homepage_url = "https://github.com/Versent/saml2aws"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "songmatrix_data-service" {
  provider = github.songmatrix
  name     = "data-service"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "songmatrix_frontend-web" {
  provider = github.songmatrix
  name     = "frontend-web"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "songmatrix_gateway" {
  provider = github.songmatrix
  name     = "gateway"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "songmatrix_github" {
  provider = github.songmatrix
  name     = ".github"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "songmatrix_sync-service" {
  provider = github.songmatrix
  name     = "sync-service"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}
