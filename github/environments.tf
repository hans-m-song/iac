resource "github_repository_environment" "hans-m-song_iac_auth0" {
  provider    = github.hans-m-song
  repository  = github_repository.hans-m-song_iac.name
  environment = "auth0"
}

resource "github_repository_environment" "hans-m-song_iac_aws" {
  provider    = github.hans-m-song
  repository  = github_repository.hans-m-song_iac.name
  environment = "aws"
}

resource "github_repository_environment" "hans-m-song_iac_github" {
  provider    = github.hans-m-song
  repository  = github_repository.hans-m-song_iac.name
  environment = "github"
}
