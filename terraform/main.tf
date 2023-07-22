module "actions" {
  source = "./modules/project"
  providers = {
    aws    = aws.ap_southeast_2
    github = github.axatol
  }

  github_repository_name        = "actions"
  enable_actions_runner_webhook = true
  enable_new_relic_webhook      = false
}

module "actions_job_dispatcher" {
  source = "./modules/project"
  providers = {
    aws    = aws.ap_southeast_2
    github = github.axatol
  }

  github_repository_name        = "actions-job-dispatcher"
  enable_actions_runner_webhook = true
  enable_new_relic_webhook      = false
}

module "blog" {
  source = "./modules/project"
  providers = {
    aws    = aws.ap_southeast_2
    github = github.hans_m_song
  }

  github_repository_name        = "blog"
  enable_actions_runner_webhook = true
  enable_new_relic_webhook      = false
}

module "huisheng" {
  source = "./modules/project"
  providers = {
    aws    = aws.ap_southeast_2
    github = github.hans_m_song
  }

  github_repository_name        = "huisheng"
  enable_actions_runner_webhook = true
  enable_new_relic_webhook      = false
}

module "iac" {
  source = "./modules/project"
  providers = {
    aws    = aws.ap_southeast_2
    github = github.hans_m_song
  }

  github_repository_name        = "iac"
  enable_actions_runner_webhook = true
  enable_new_relic_webhook      = true
}
