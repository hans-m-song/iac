resource "aws_iam_group" "users" {
  provider = aws.apse2
  name     = "users"
}

resource "aws_iam_group_policy_attachment" "user_self_service" {
  provider   = aws.apse2
  group      = aws_iam_group.users.name
  policy_arn = aws_iam_policy.user_access_self_service.arn
}

resource "aws_iam_group_policy_attachment" "power_users" {
  provider   = aws.apse2
  group      = aws_iam_group.users.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}
