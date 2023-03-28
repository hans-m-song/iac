resource "auth0_resource_server" "jayd_server" {
  name        = "Just Another Youtube Downloader - Server"
  identifier  = "https://api.jayd.k8s.axatol.xyz"
  signing_alg = "RS256"

  scopes { value = "youtube:metadata" }
  scopes { value = "youtube:download" }
}

locals {
  jayd_server-scopes = [
    "youtube:metadata",
    "youtube:download",
  ]
}

resource "auth0_resource_server" "deep_thought_server" {
  name        = "deep-thought - Cluster Gateway"
  identifier  = "https://k8s.axatol.xyz"
  signing_alg = "RS256"
}
