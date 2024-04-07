resource "aws_iam_openid_connect_provider" "github_actions" {
  provider       = aws.apse2
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
  ]
}

module "cdk_lookup_github_actions_role" {
  providers = { aws = aws.apse2 }
  source    = "./modules/github_actions_role"
  name      = "service-account-github-actions-cdk-lookup"

  subject_claims = [
    { repo = "hans-m-song/iac", branch = "master", actor = "hans-m-song" },
  ]

  managed_policy_arns = [
    aws_iam_policy.assume_cdk_lookup_role.arn,
  ]
}

resource "aws_ssm_parameter" "cdk_lookup_github_actions_role" {
  provider = aws.apse2
  name     = "/infrastructure/github_actions/cdk_lookup_role_arn"
  type     = "String"
  value    = module.cdk_lookup_github_actions_role.arn
}

module "cdk_deploy_github_actions_role" {
  providers = { aws = aws.apse2 }
  source    = "./modules/github_actions_role"
  name      = "service-account-github-actions-cdk-deploy"

  subject_claims = [
    { repo = "hans-m-song/iac", branch = "master", actor = "hans-m-song" },
  ]

  managed_policy_arns = [
    aws_iam_policy.assume_cdk_lookup_role.arn,
    aws_iam_policy.assume_cdk_deploy_role.arn,
  ]
}

resource "aws_ssm_parameter" "cdk_deploy_github_actions_role" {
  provider = aws.apse2
  name     = "/infrastructure/github_actions/cdk_deploy_role_arn"
  type     = "String"
  value    = module.cdk_deploy_github_actions_role.arn
}

module "ecr_publisher_github_actions_role" {
  providers = { aws = aws.apse2 }
  source    = "./modules/github_actions_role"
  name      = "service-account-github-actions-ecr-publisher"

  subject_claims = [
    { repo = "axatol/*", branch = "master", actor = "hans-m-song" },
    { repo = "hans-m-song/huisheng", branch = "master", actor = "hans-m-song" },
    { repo = "hans-m-song/iac", branch = "master", actor = "hans-m-song", },
  ]

  managed_policy_arns = [
    aws_iam_policy.ecr_publisher.arn,
  ]
}

resource "aws_ssm_parameter" "ecr_publisher_github_actions_role" {
  provider = aws.apse2
  name     = "/infrastructure/github_actions/ecr_publisher_role_arn"
  type     = "String"
  value    = module.ecr_publisher_github_actions_role.arn
}

module "cloudfront_invalidator_github_actions_role" {
  providers = { aws = aws.apse2 }
  source    = "./modules/github_actions_role"
  name      = "service-account-github-actions-cloudfront-invalidator"

  subject_claims = [
    { repo = "hans-m-song/blog", branch = "master", actor = "*" },
    { repo = "hans-m-song/blog", environment = "public", actor = "*" },
  ]

  managed_policy_arns = [
    aws_iam_policy.cloudfront_invalidator.arn,
  ]
}

resource "aws_ssm_parameter" "cloudfront_invalidator_github_actions_role" {
  provider = aws.apse2
  name     = "/infrastructure/github_actions/cloudfront_invalidator_role_arn"
  type     = "String"
  value    = module.cloudfront_invalidator_github_actions_role.arn
}
