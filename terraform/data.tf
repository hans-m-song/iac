data "aws_ssm_parameter" "dockerhub_access_token" {
  name = "/infrastructure/terraform/dockerhub_access_token"
}

data "aws_ssm_parameter" "dockerhub_username" {
  name = "/infrastructure/terraform/dockerhub_username"
}

data "octopusdeploy_space" "default" {
  name = "Default"
}
