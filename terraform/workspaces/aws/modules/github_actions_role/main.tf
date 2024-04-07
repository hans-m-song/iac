data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.provider_id}",
      ]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "${var.provider_id}:aud"
      values   = var.client_ids
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "${var.provider_id}:sub"
      values = concat(
        [
          for claim in var.subject_claims :
          "repo:${claim.repo}:ref:refs/heads/${claim.branch}:actor:${claim.actor}"
          if claim.branch != null
        ],
        [
          for claim in var.subject_claims :
          "repo:${claim.repo}:ref:refs/tags/${claim.tag}:actor:${claim.actor}"
          if claim.tag != null
        ],
        [
          for claim in var.subject_claims :
          "repo:${claim.repo}:environment:${claim.environment}:actor:${claim.actor}"
          if claim.environment != null
        ],
        [
          for claim in var.subject_claims :
          "repo:${claim.repo}:pull_request:actor:${claim.actor}"
          if claim.pull_request == true
        ],
      )
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = var.name
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns  = var.managed_policy_arns
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary
}
