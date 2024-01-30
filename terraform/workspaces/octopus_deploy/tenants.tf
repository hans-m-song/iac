resource "octopusdeploy_tag_set" "platforms" {
  name = "platforms"
}

resource "octopusdeploy_tag" "kubernetes" {
  tag_set_id = octopusdeploy_tag_set.platforms.id
  name       = "kubernetes"
  color      = "#333333"
}

resource "octopusdeploy_tag" "aws" {
  tag_set_id = octopusdeploy_tag_set.platforms.id
  name       = "aws"
  color      = "#333333"
}

resource "octopusdeploy_tag_set" "regions" {
  name = "regions"
}

resource "octopusdeploy_tag" "region_apse2" {
  tag_set_id = octopusdeploy_tag_set.regions.id
  name       = "ap-southeast-2"
  color      = "#FF9900"
}

resource "octopusdeploy_tag" "region_use1" {
  tag_set_id = octopusdeploy_tag_set.regions.id
  name       = "us-east-1"
  color      = "#FF9900"
}

resource "octopusdeploy_tag_set" "clusters" {
  name = "clusters"
}

resource "octopusdeploy_tag" "cluster_wheatley" {
  tag_set_id = octopusdeploy_tag_set.clusters.id
  name       = "wheatley"
  color      = "#3970E4"
}

resource "octopusdeploy_tenant" "apse2" {
  name = "ap-southeast-2"
  tenant_tags = [
    octopusdeploy_tag.aws.canonical_tag_name,
    octopusdeploy_tag.region_apse2.canonical_tag_name,
  ]
}

resource "octopusdeploy_tenant" "use1" {
  name = "us-east-1"
  tenant_tags = [
    octopusdeploy_tag.aws.canonical_tag_name,
    octopusdeploy_tag.region_use1.canonical_tag_name,
  ]
}

resource "octopusdeploy_tenant" "wheatley" {
  name = "wheatley"
  tenant_tags = [
    octopusdeploy_tag.kubernetes.canonical_tag_name,
    octopusdeploy_tag.cluster_wheatley.canonical_tag_name,
  ]
}
