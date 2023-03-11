resource "github_repository_environment" "hans_m_song-iac-auth0" {
  provider    = github.hans_m_song
  repository  = github_repository.hans_m_song-iac.name
  environment = "auth0"
}

resource "github_repository_environment" "hans_m_song-iac-aws" {
  provider    = github.hans_m_song
  repository  = github_repository.hans_m_song-iac.name
  environment = "aws"
}

resource "github_repository_environment" "hans_m_song-iac-github" {
  provider    = github.hans_m_song
  repository  = github_repository.hans_m_song-iac.name
  environment = "github"
}

resource "github_repository_environment" "hans_m_song-huisheng-deep_thought" {
  provider    = github.hans_m_song
  repository  = github_repository.hans_m_song-huisheng.name
  environment = "deep-thought"

  reviewers {
    users = [
      local.github_user_hans_m_song,
    ]
  }
}
