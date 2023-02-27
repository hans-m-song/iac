resource "auth0_client_grant" "jayd_server" {
  for_each = toset([
    auth0_client.jayd_server_test_application.id,
    auth0_client.jayd_web.id,
    auth0_client.jayd_web_dev.id,
  ])

  client_id = each.value
  audience  = auth0_resource_server.jayd_server.identifier
  scope     = local.jayd_server-scopes
}
