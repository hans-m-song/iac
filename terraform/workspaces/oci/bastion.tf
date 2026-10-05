variable "bastion_client_ip" {
  type        = string
  description = "Public IPv4 address permitted to connect to OCI Bastion sessions."

  validation {
    condition = alltrue([
      can(cidrhost("${var.bastion_client_ip}/32", 0)),
      !can(regex("^(0|10|127)\\.", var.bastion_client_ip)),
      !can(regex("^100\\.(6[4-9]|[7-9][0-9]|1[01][0-9]|12[0-7])\\.", var.bastion_client_ip)),
      !can(regex("^169\\.254\\.", var.bastion_client_ip)),
      !can(regex("^172\\.(1[6-9]|2[0-9]|3[0-1])\\.", var.bastion_client_ip)),
      !can(regex("^192\\.(0\\.(0|2)|168)\\.", var.bastion_client_ip)),
      !can(regex("^198\\.(1[89]|51\\.100)\\.", var.bastion_client_ip)),
      !can(regex("^203\\.0\\.113\\.", var.bastion_client_ip)),
      !can(regex("^(22[4-9]|23[0-9]|24[0-9]|25[0-5])\\.", var.bastion_client_ip)),
    ])
    error_message = "bastion_client_ip must be a globally routable IPv4 address."
  }
}

resource "oci_bastion_bastion" "aperture" {
  bastion_type                 = "STANDARD"
  client_cidr_block_allow_list = ["${var.bastion_client_ip}/32"]
  compartment_id               = var.oci_tenancy_ocid
  max_session_ttl_in_seconds   = 10800
  name                         = "ApertureBastion"
  target_subnet_id             = oci_core_subnet.aperture_private.id
}

resource "oci_core_network_security_group_security_rule" "application_ssh_from_bastion" {
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.aperture_application.id
  protocol                  = local.transport_protocol_tcp
  source                    = "${oci_bastion_bastion.aperture.private_endpoint_ip_address}/32"
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}
