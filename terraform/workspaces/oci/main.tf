locals {
  compartment_id = var.oci_tenancy_ocid
  sydney_ad_name = data.oci_identity_availability_domain.sydney.name

  amd_instance_shape_name       = "VM.Standard.E2.1.Micro"
  amd_canonical_ubuntu_image_id = data.oci_core_images.amd_canonical_ubuntu.images[0].id
  amd_oracle_linux_image_id     = data.oci_core_images.amd_oracle_linux.images[0].id

  arm_instance_shape_name       = "VM.Standard.A1.Flex"
  arm_canonical_ubuntu_image_id = data.oci_core_images.arm_canonical_ubuntu.images[0].id
  arm_oracle_linux_image_id     = data.oci_core_images.arm_oracle_linux.images[0].id

  transport_protocol_all    = "all"
  transport_protocol_icmp   = "1"
  transport_protocol_tcp    = "6"
  transport_protocol_udp    = "17"
  transport_protocol_icmpv6 = "58"

  vcn_cidr            = "10.10.0.0/16"
  private_subnet_cidr = "10.10.1.0/24"
  public_subnet_cidr  = "10.10.2.0/24"
  natgw_private_ip    = "10.10.1.200"
  natgw_private_ip_id = data.oci_core_private_ips.natgw_private.private_ips[0].id
  # natgw_instance_cloud_init_user_data = base64encode(templatefile("${path.module}/templates/natgw.cloud-init.yaml.tftpl", {lan_ip = local.natgw_private_ip }))
}

resource "oci_core_network_security_group" "natgw_public" {
  vcn_id         = oci_core_vcn.default.id
  compartment_id = local.compartment_id
  display_name   = "Public NATGW Security Group"
}

resource "oci_core_network_security_group_security_rule" "natgw_public_egress_icmp" {
  network_security_group_id = oci_core_network_security_group.natgw_public.id
  direction                 = "EGRESS"
  protocol                  = local.transport_protocol_icmp
  destination_type          = "CIDR_BLOCK"
  destination               = "127.0.0.1/32"
}

resource "oci_core_network_security_group_security_rule" "natgw_public_egress_https" {
  network_security_group_id = oci_core_network_security_group.natgw_public.id
  direction                 = "EGRESS"
  protocol                  = local.transport_protocol_tcp
  destination_type          = "CIDR_BLOCK"
  destination               = "127.0.0.1/32"

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "natgw_public_ingress_icmp" {
  network_security_group_id = oci_core_network_security_group.natgw_public.id
  direction                 = "INGRESS"
  protocol                  = local.transport_protocol_icmp
  source_type               = "CIDR_BLOCK"
  source                    = "127.0.0.1/32"
}

resource "oci_core_network_security_group_security_rule" "natgw_public_ingress_ssh" {
  network_security_group_id = oci_core_network_security_group.natgw_public.id
  direction                 = "INGRESS"
  protocol                  = local.transport_protocol_tcp
  source_type               = "CIDR_BLOCK"
  source                    = "0.0.0.0/0"
}

resource "oci_core_instance" "natgw" {
  compartment_id      = local.compartment_id
  availability_domain = local.sydney_ad_name
  shape               = local.arm_instance_shape_name

  shape_config {
    ocpus         = 1
    memory_in_gbs = 6
  }

  create_vnic_details {
    display_name           = "public"
    subnet_id              = oci_core_subnet.public.id
    nsg_ids                = [oci_core_network_security_group.natgw_public.id]
    assign_public_ip       = true
    skip_source_dest_check = true
  }

  source_details {
    source_type = "image"
    source_id   = local.arm_canonical_ubuntu_image_id
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "oci_core_network_security_group" "natgw_private" {
  vcn_id         = oci_core_vcn.default.id
  compartment_id = local.compartment_id
  display_name   = "Private NATGW Security Group"
}

resource "oci_core_network_security_group_security_rule" "natgw_private_egress_icmp" {
  network_security_group_id = oci_core_network_security_group.natgw_private.id
  direction                 = "EGRESS"
  protocol                  = local.transport_protocol_icmp
  destination_type          = "CIDR_BLOCK"
  destination               = "127.0.0.1/32"
}

resource "oci_core_network_security_group_security_rule" "natgw_private_ingress_icmp" {
  network_security_group_id = oci_core_network_security_group.natgw_private.id
  direction                 = "INGRESS"
  protocol                  = local.transport_protocol_icmp
  source_type               = "CIDR_BLOCK"
  source                    = "127.0.0.1/32"
}

resource "oci_core_vnic_attachment" "natgw_private" {
  instance_id = oci_core_instance.natgw.id

  create_vnic_details {
    display_name           = "private"
    hostname_label         = "natgw"
    private_ip             = local.natgw_private_ip
    subnet_id              = oci_core_subnet.private.id
    nsg_ids                = [oci_core_network_security_group.natgw_private.id]
    assign_public_ip       = false
    skip_source_dest_check = true
  }

  depends_on = [oci_core_instance.natgw]
}

# resource "oci_core_instance" "pbody" {
#   shape = local.amd_instance_shape_name
# }

# resource "oci_core_instance" "morality" {
#   shape = local.arm_instance_shape
# }

# resource "oci_core_instance" "curiosity" {
#   shape = local.arm_instance_shape
# }

# resource "oci_core_instance" "intelligence" {
#   shape = local.arm_instance_shape
# }

# resource "oci_core_instance" "anger" {
#   shape = local.arm_instance_shape
# }
