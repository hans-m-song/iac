locals {
  sydney_ad_name = data.oci_identity_availability_domain.sydney.name

  amd_instance_shape_name       = "VM.Standard.E2.1.Micro"
  amd_canonical_ubuntu_image_id = data.oci_core_images.amd_canonical_ubuntu.images[0].id

  arm_instance_shape_name       = "VM.Standard.A1.Flex"
  arm_canonical_ubuntu_image_id = data.oci_core_images.arm_canonical_ubuntu.images[0].id
}

data "oci_core_images" "amd_canonical_ubuntu" {
  compartment_id           = var.oci_tenancy_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = local.amd_instance_shape_name
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_core_images" "arm_canonical_ubuntu" {
  compartment_id           = var.oci_tenancy_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04 Minimal aarch64"
  shape                    = local.arm_instance_shape_name
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_identity_availability_domain" "sydney" {
  compartment_id = var.oci_tenancy_ocid
  ad_number      = 1
}
