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
