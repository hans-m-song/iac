data "octopusdeploy_feeds" "built_in" {
  feed_type = "BuiltIn"
  count     = 1
  take      = 1
}

data "octopusdeploy_space" "default" {
  name = "Default"
}

data "auth0_tenant" "this" {
}
