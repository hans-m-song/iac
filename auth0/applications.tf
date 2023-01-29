resource "auth0_client" "deep-thought_minio-idp" {
  name     = "deep-thought - Minio IDP"
  app_type = "regular_web"
}

resource "auth0_client" "deep-thought_cluster-gateway" {
  name     = "deep-thought cluster gateway"
  app_type = "regular_web"
}

resource "auth0_client" "terraform_auth0-provider" {
  name     = "Terraform Auth0 Provider"
  app_type = "non_interactive"
}
