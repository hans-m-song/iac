data "oci_core_images" "amd_canonical_ubuntu" {
  compartment_id           = local.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
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
  operating_system_version = "22.04 Minimal aarch64"
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

data "oci_core_private_ips" "natgw_private" {
  vnic_id    = oci_core_vnic_attachment.natgw_private.vnic_id
  depends_on = [oci_core_vnic_attachment.natgw_private]
}

# resource "terraform_data" "test" {
#   input = data.oci_identity_availability_domain.sydney
# }

# data "oci_core_private_ips" "natgw" {

# }
