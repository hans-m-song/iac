resource "auth0_client" "deep_thought_client" {
  name     = "deep-thought - Cluster Client"
  app_type = "non_interactive"
}

resource "auth0_client" "jayd_server_test_application" {
  name     = "Just Another Youtube Downloader - Server (Test Application)"
  app_type = "non_interactive"
}

resource "auth0_client" "jayd_web" {
  name                       = "Just Another Youtube Downloader - Web"
  app_type                   = "spa"
  token_endpoint_auth_method = "none"
  oidc_conformant            = true
  web_origins                = ["https://jayd.axatol.xyz", "https://jayd.k8s.axatol.xyz"]
  callbacks                  = ["https://jayd.axatol.xyz", "https://jayd.k8s.axatol.xyz"]
  allowed_logout_urls        = ["https://jayd.axatol.xyz", "https://jayd.k8s.axatol.xyz"]
  jwt_configuration { alg = "RS256" }
}

resource "auth0_client" "jayd_web_dev" {
  name                       = "Just Another Youtube Downloader - Web (dev)"
  app_type                   = "spa"
  token_endpoint_auth_method = "none"
  oidc_conformant            = true
  web_origins                = ["http://localhost:5173", "http://localhost:8000"]
  callbacks                  = ["http://localhost:5173", "http://localhost:8000"]
  allowed_logout_urls        = ["http://localhost:5173", "http://localhost:8000"]
  jwt_configuration { alg = "RS256" }
}

resource "auth0_client" "terraform_auth0_provider" {
  name     = "Terraform Auth0 Provider"
  app_type = "non_interactive"
}
