locals {
  # natgw_private_ip_id = data.oci_core_private_ips.natgw_private.private_ips[0].id
  # natgw_instance_cloud_init_user_data = base64encode(templatefile("${path.module}/templates/natgw.cloud-init.yaml.tftpl", {lan_ip = local.natgw_private_ip }))
}

# resource "oci_core_public_ip" "grady" {
#   compartment_id = var.oci_tenancy_ocid
#   lifetime       = "RESERVED"
# }

resource "oci_core_private_ip" "grady" {
  hostname_label = "grady"
  display_name   = "public"
  ip_address     = "10.10.2.10"

  lifecycle {
    ignore_changes = [vnic_id]
  }
}

resource "oci_core_instance" "grady" {
  compartment_id      = var.oci_tenancy_ocid
  availability_domain = local.sydney_ad_name
  shape               = local.arm_instance_shape_name

  shape_config {
    ocpus         = 4
    memory_in_gbs = 24
  }

  create_vnic_details {
    display_name           = "public"
    hostname_label         = "grady"
    subnet_id              = oci_core_subnet.public.id
    private_ip             = "10.10.2.10"
    assign_public_ip       = true
    skip_source_dest_check = false
  }

  source_details {
    source_type = "image"
    source_id   = local.arm_canonical_ubuntu_image_id
  }

  lifecycle {
    ignore_changes = [metadata, source_details[0].source_id]
  }
}
