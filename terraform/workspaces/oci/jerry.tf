resource "oci_core_public_ip" "nlb" {
  compartment_id = var.oci_tenancy_ocid
  private_ip_id  = oci_core_private_ip.public_gateway.id
  lifetime       = "RESERVED"
}

resource "oci_core_private_ip" "public_gateway" {
  ip_address = "10.10.2.2"

  lifecycle {
    ignore_changes = [vnic_id]
  }
}

resource "oci_network_load_balancer_network_load_balancer" "nlb" {
  compartment_id = var.oci_tenancy_ocid
  subnet_id      = oci_core_subnet.public.id
  display_name   = "nlb"
}

resource "oci_network_load_balancer_listener" "https" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  name                     = "https"
  default_backend_set_name = oci_network_load_balancer_backend_set.jerry.name
  port                     = 443
  protocol                 = "TCP_AND_UDP"
}

resource "oci_network_load_balancer_backend_set" "jerry" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  name                     = "jerry"
  policy                   = "FIVE_TUPLE"
  health_checker {
    protocol = "TCP"
    port     = 443
  }
}

resource "oci_network_load_balancer_backend" "jerry" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  backend_set_name         = oci_network_load_balancer_backend_set.jerry.name
  target_id                = oci_core_instance.jerry.id
  port                     = 443
}

resource "oci_core_instance" "jerry" {
  compartment_id      = var.oci_tenancy_ocid
  availability_domain = local.sydney_ad_name
  shape               = local.amd_instance_shape_name

  shape_config {
    ocpus         = 1
    memory_in_gbs = 1
  }

  create_vnic_details {
    display_name           = "private"
    subnet_id              = oci_core_subnet.private.id
    assign_public_ip       = false
    skip_source_dest_check = false
    hostname_label         = "jerry"
  }

  source_details {
    source_type = "image"
    source_id   = local.amd_canonical_ubuntu_image_id
  }

  lifecycle {
    ignore_changes = [metadata, source_details[0].source_id]
  }
}
