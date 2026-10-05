resource "oci_core_public_ip" "nlb" {
  compartment_id = var.oci_tenancy_ocid
  private_ip_id  = oci_core_private_ip.public_gateway.id
  lifetime       = "RESERVED"
}

resource "oci_core_private_ip" "public_gateway" {
  ip_address = local.nlb_private_ip

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
  default_backend_set_name = oci_network_load_balancer_backend_set.ingress.name
  port                     = 443
  protocol                 = "TCP"
}

resource "oci_network_load_balancer_backend_set" "ingress" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  name                     = "ingress"
  policy                   = "FIVE_TUPLE"

  # CrowdSec bans by IP. Without this, every request reaches Traefik with the
  # load balancer's address and a single ban would take the whole site down.
  is_preserve_source = true

  health_checker {
    protocol = "TCP"
    port     = 443
  }
}

resource "oci_network_load_balancer_backend" "grady" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  backend_set_name         = oci_network_load_balancer_backend_set.ingress.name
  target_id                = oci_core_instance.grady.id
  port                     = 443
}
