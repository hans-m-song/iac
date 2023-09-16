output "client_id" {
  value = auth0_client.this.id
}

output "resource_server_identifier" {
  value = auth0_resource_server.this.identifier
}

output "scopes" {
  value = var.scopes
}

output "scope_names" {
  value = local.scope_names
}
