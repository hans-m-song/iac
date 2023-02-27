resource "auth0_resource_server" "jayd_server" {
  name        = "Just Another Youtube Downloader - Server"
  identifier  = "https://api.jayd.k8s.axatol.xyz"
  signing_alg = "RS256"

  scopes { value = "read:youtube_metadata" }
  scopes { value = "create:youtube_download" }
}

locals {
  jayd_server-scopes = [
    "read:youtube_metadata",
    "create:youtube_download",
  ]
}
