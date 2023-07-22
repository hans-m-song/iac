resource "github_actions_secret" "this" {
  for_each = merge(
    var.github_repository_actions_secrets,
    var.enable_aws_cdk_deploy ? {
      "AWS_DEFAULT_REGION"      = "ap-southeast-2"
      "AWS_CDK_DEPLOY_ROLE_ARN" = data.aws_ssm_parameter.github_actions_cdk_deploy_role_arn[0].value,
      "AWS_CDK_DIFF_ROLE_ARN"   = data.aws_ssm_parameter.github_actions_cdk_diff_role_arn[0].value,
    } : {},
    var.enable_aws_ecr_publish ? {
      "AWS_ECR_IMAGE_PUBLISHER_ROLE_ARN" = data.aws_ssm_parameter.github_actions_ecr_image_publisher_role_arn[0].value,
    } : {},
  )

  repository      = var.github_repository_name
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_actions_repository_oidc_subject_claim_customization_template" "this" {
  repository  = data.github_repository.this.name
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
  repository = data.github_repository.this.name
  active     = true
  events     = ["workflow_job"]

  configuration {
    content_type = "json"
    url          = data.aws_ssm_parameter.github_actions_runner_webhook_url[0].value
  }
}

resource "github_repository_webhook" "new_relic" {
  count      = var.enable_new_relic_webhook ? 1 : 0
  repository = data.github_repository.this.name
  active     = true
  events     = ["workflow_job"]

  configuration {
    content_type = "json"
    url          = "https://log-api.newrelic.com/log/v1?Api-Key=${data.aws_ssm_parameter.github_new_relic_license_key[0].value}"
  }
}
