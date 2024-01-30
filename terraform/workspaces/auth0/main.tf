resource "auth0_resource_server" "glados" {
  identifier             = "https://glados.k8s.axatol.xyz"
  name                   = "Glados"
  signing_alg            = "RS256"
  token_lifetime         = 86400
  token_lifetime_for_web = 7200
  allow_offline_access   = false
}

resource "auth0_client" "glados_cli" {
  name           = "Glados (CLI)"
  app_type       = "non_interactive"
  is_first_party = true
  sso            = false
  callbacks      = ["http://localhost:8000"]

  grant_types = [
    "client_credentials",
    "refresh_token",
    "authorization_code",
    "implicit",
  ]

  jwt_configuration {
    alg                 = "RS256"
    lifetime_in_seconds = 36000
  }
}

resource "auth0_client" "minio" {
  name      = "Minio"
  app_type  = "regular_web"
  callbacks = ["https://minio.k8s.axatol.xyz/oauth_callback"]
}

resource "auth0_client" "flipt" {
  name      = "Flipt"
  app_type  = "spa"
  callbacks = ["https://flipt.axatol.xyz/auth/v1/method/oidc/auth0/callback"]
}

resource "auth0_role" "ssor_administrator" {
  name        = "SSOR_Administrator"
  description = "Managed by terraform"
}

resource "auth0_role" "ssor_minio_readonly" {
  name        = "SSOR_Minio_ReadOnly"
  description = "Managed by terraform"
}

resource "auth0_role" "ssor_minio_readwrite" {
  name        = "SSOR_Minio_ReadWrite"
  description = "Managed by terraform"
}
