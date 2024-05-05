output "account_id" {
  value = local.account_id
}

output "custom_resource_permissions_boundary_arn" {
  value = aws_iam_policy.custom_resource_permissions_boundary.arn
}

output "deployment_permissions_boundary_arn" {
  value = aws_iam_policy.deployment_permissions_boundary.arn
}

output "lambda_permissions_boundary_arn" {
  value = aws_iam_policy.lambda_permissions_boundary.arn
}

output "github_actions_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github_actions.arn
}

output "cdk_lookup_github_actions_role_arn" {
  value = module.cdk_lookup_github_actions_role.arn
}

output "cdk_deploy_github_actions_role_arn" {
  value = module.cdk_deploy_github_actions_role.arn
}

output "ecr_publisher_github_actions_role_arn" {
  value = module.ecr_publisher_github_actions_role.arn
}

output "cloudfront_invalidator_github_actions_role_arn" {
  value = module.cloudfront_invalidator_github_actions_role.arn
}
