resource "github_actions_secret" "this" {
  for_each = merge(
    {
      # "AWS_DEFAULT_REGION"               = "ap-southeast-2"
      "AWS_CDK_DEPLOY_ROLE_ARN"          = var.parameters.github_actions_cdk_deploy_role_arn
      "AWS_CDK_DIFF_ROLE_ARN"            = var.parameters.github_actions_cdk_diff_role_arn
      "AWS_ECR_IMAGE_PUBLISHER_ROLE_ARN" = var.parameters.github_actions_ecr_image_publisher_role_arn
      "NEW_RELIC_API_KEY"                = var.parameters.github_actions_new_relic_api_key
      "DISCORD_WEBHOOK_URL"              = var.parameters.github_actions_discord_webhook_url
    },
    var.github_repository_actions_secrets,
  )

  repository      = var.github_repository_name
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_actions_variable" "this" {
  for_each      = var.github_repository_actions_variables
  repository    = var.github_repository_name
  variable_name = "value"
  value         = "value"
}

resource "github_actions_repository_oidc_subject_claim_customization_template" "this" {
  repository  = var.github_repository_name
  use_default = false

  include_claim_keys = [
    "repo",
    "context",
    "job_workflow_ref",
    "actor",
  ]
}

resource "github_repository_webhook" "actions_runner" {
  count      = var.enable_actions_runner_webhook ? 1 : 0
  repository = var.github_repository_name
  active     = true
  events     = ["workflow_job"]

  configuration {
    content_type = "json"
    url          = var.parameters.github_actions_runner_webhook_url
  }
}

resource "github_repository_webhook" "new_relic" {
  count      = var.enable_new_relic_webhook ? 1 : 0
  repository = var.github_repository_name
  active     = true
  events     = ["workflow_job"]

  configuration {
    content_type = "json"
    url          = "https://log-api.newrelic.com/log/v1?Api-Key=${var.parameters.github_new_relic_license_key}"
  }
}
