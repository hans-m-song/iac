resource "auth0_client" "test_client" {
  name        = "Test Client"
  description = "Test Client"
  app_type    = "non_interactive"
}
