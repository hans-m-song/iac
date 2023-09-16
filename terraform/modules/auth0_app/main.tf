locals {
  scope_names = [for name, value in var.scopes : name]
}

resource "auth0_resource_server" "this" {
  identifier             = var.identifier
  name                   = var.name
  signing_alg            = "RS256"
  token_lifetime         = 86400
  token_lifetime_for_web = 7200
  allow_offline_access   = false
  token_dialect          = "access_token"
}

resource "auth0_resource_server_scopes" "this" {
  resource_server_identifier = auth0_resource_server.this.identifier

  dynamic "scopes" {
    for_each = var.scopes
    content {
      name        = scopes.key
      description = scopes.value
    }
  }
}

resource "auth0_client" "this" {
  name                = var.name
  app_type            = "spa"
  is_first_party      = true
  sso                 = false
  grant_types         = ["authorization_code", "implicit", "refresh_token"]
  callbacks           = var.client_origins
  allowed_logout_urls = var.client_origins
  web_origins         = var.client_origins
  allowed_origins     = var.client_origins

  jwt_configuration {
    alg                 = "RS256"
    lifetime_in_seconds = 36000
    scopes              = {}
  }
}

resource "auth0_client_credentials" "this" {
  client_id             = auth0_client.this.id
  authentication_method = "client_secret_post"
}

resource "auth0_client_grant" "this" {
  audience  = auth0_resource_server.this.identifier
  client_id = auth0_client.this.client_id
  scopes    = local.scope_names
}
