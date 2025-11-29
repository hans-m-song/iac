data "oci_core_images" "amd_canonical_ubuntu" {
  compartment_id           = local.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = local.amd_instance_shape_name
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_core_images" "amd_oracle_linux" {
  compartment_id           = local.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = local.amd_instance_shape_name
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_core_images" "arm_canonical_ubuntu" {
  compartment_id           = local.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04 Minimal aarch64"
  shape                    = local.arm_instance_shape_name
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_core_images" "arm_oracle_linux" {
  compartment_id           = local.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = local.arm_instance_shape_name
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_identity_availability_domain" "sydney" {
  compartment_id = local.compartment_id
  ad_number      = 1
}
