resource "oci_artifacts_container_repository" "folio" {
  compartment_id = var.oci_tenancy_ocid
  display_name   = "folio"
  is_public      = false
  is_immutable   = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "oci_identity_dynamic_group" "grady_ocir" {
  compartment_id = var.oci_tenancy_ocid
  name           = "grady-folio-ocir-puller"
  description    = "Grady instance access to pull images from the folio repository"
  matching_rule  = "instance.id = '${oci_core_instance.grady.id}'"
}

resource "oci_identity_policy" "folio" {
  compartment_id = var.oci_tenancy_ocid
  name           = "folio-service-account"
  description    = "Folio app permissions"
  statements = [
    <<-IAM
    Allow dynamic-group ${oci_identity_dynamic_group.grady_ocir.name} to read repos in tenancy where all {
      target.repo.name = '${oci_artifacts_container_repository.folio.display_name}',
      target.compartment.id = '${oci_artifacts_container_repository.folio.compartment_id}'
    }
    IAM
  ]
}
