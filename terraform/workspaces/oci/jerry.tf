# resource "oci_core_instance" "jerry" {
#   compartment_id      = var.oci_tenancy_ocid
#   availability_domain = local.sydney_ad_name
#   shape               = local.amd_instance_shape_name

#   shape_config {
#     ocpus         = 1
#     memory_in_gbs = 1
#   }

#   create_vnic_details {
#     display_name           = "private"
#     subnet_id              = oci_core_subnet.private.id
#     assign_public_ip       = false
#     skip_source_dest_check = false
#     hostname_label         = "jerry"
#   }

#   source_details {
#     source_type = "image"
#     source_id   = local.amd_canonical_ubuntu_image_id
#   }

#   lifecycle {
#     ignore_changes = [metadata, source_details[0].source_id]
#   }
# }
