resource "github_repository" "axatol-actions" {
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

resource "github_repository" "axatol-actions_runner_broker" {
  provider = github.axatol
  name     = "actions-runner-broker"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "axatol-aws_dynamic_dns" {
  provider = github.axatol
  name     = "aws-dynamic-dns"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "axatol-esoteriguard" {
  provider    = github.axatol
  name        = "esoteriguard"
  description = "vpn stack for bypassing the gfw"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "axatol-home_assistant_integrations" {
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

resource "github_repository" "axatol-hookshot_artillery" {
  provider = github.axatol
  name     = "hookshot-artillery"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "axatol-jayd" {
  provider    = github.axatol
  name        = "jayd"
  description = "Just Another Youtube Downloader"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "axatol-whats_up" {
  provider    = github.axatol
  name        = "whats-up"
  description = "kindle dashboard for morning notices"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "axatol-where_gate" {
  provider    = github.axatol
  name        = "where-gate"
  description = "when is baldurs gate coming out?"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

locals {
  github_repositories_axatol = [
    github_repository.axatol-actions.name,
    github_repository.axatol-actions_runner_broker.name,
    github_repository.axatol-aws_dynamic_dns.name,
    github_repository.axatol-esoteriguard.name,
    github_repository.axatol-home_assistant_integrations.name,
    github_repository.axatol-hookshot_artillery.name,
    github_repository.axatol-jayd.name,
    github_repository.axatol-whats_up.name,
    github_repository.axatol-where_gate.name,
  ]
}

resource "github_repository" "hans_m_song-blog" {
  provider = github.hans_m_song
  name     = "blog"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "hans_m_song-huisheng" {
  provider    = github.hans_m_song
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

resource "github_repository" "hans_m_song-iac" {
  provider = github.hans_m_song
  name     = "iac"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "hans_m_song-kube_stack" {
  provider    = github.hans_m_song
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

resource "github_repository" "hans_m_song-saml2aws" {
  provider     = github.hans_m_song
  name         = "saml2aws"
  description  = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP"
  homepage_url = "https://github.com/Versent/saml2aws"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

locals {
  github_repositories_hans_m_song = [
    github_repository.hans_m_song-blog.name,
    github_repository.hans_m_song-huisheng.name,
    github_repository.hans_m_song-iac.name,
    github_repository.hans_m_song-kube_stack.name,
    github_repository.hans_m_song-saml2aws.name,
  ]
}

resource "github_repository" "songmatrix-data_service" {
  provider = github.songmatrix
  name     = "data-service"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "songmatrix-frontend_web" {
  provider = github.songmatrix
  name     = "frontend-web"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "songmatrix-gateway" {
  provider = github.songmatrix
  name     = "gateway"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "songmatrix-github" {
  provider = github.songmatrix
  name     = ".github"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

resource "github_repository" "songmatrix-sync_service" {
  provider = github.songmatrix
  name     = "sync-service"

  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true
}

locals {
  github_repositories_songmatrix = [
    github_repository.songmatrix-data_service.name,
    github_repository.songmatrix-frontend_web.name,
    github_repository.songmatrix-gateway.name,
    github_repository.songmatrix-github.name,
    github_repository.songmatrix-sync_service.name,
  ]
}
