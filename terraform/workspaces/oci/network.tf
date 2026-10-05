locals {
  transport_protocol_all    = "all"
  transport_protocol_icmp   = "1"
  transport_protocol_tcp    = "6"
  transport_protocol_udp    = "17"
  transport_protocol_icmpv6 = "58"

  vcn_cidr            = "10.10.0.0/16"
  private_subnet_cidr = "10.10.1.0/24"
  public_subnet_cidr  = "10.10.2.0/24"
  natgw_private_ip    = "10.10.1.200"
  nlb_private_ip      = "10.10.2.2"
  grady_private_ip    = "10.10.2.10"
}

resource "oci_core_vcn" "default" {
  compartment_id = var.oci_tenancy_ocid
  cidr_blocks    = [local.vcn_cidr]
  dns_label      = "default"
  display_name   = "Default Virtual Cloud Network"
}

resource "oci_core_internet_gateway" "default" {
  vcn_id         = oci_core_vcn.default.id
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Default Internet Gateway"
}

resource "oci_core_route_table" "public" {
  vcn_id         = oci_core_vcn.default.id
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Public Route Table"

  route_rules {
    network_entity_id = oci_core_internet_gateway.default.id
    destination_type  = "CIDR_BLOCK"
    destination       = "0.0.0.0/0"
  }
}

resource "oci_core_security_list" "public_subnet" {
  compartment_id = var.oci_tenancy_ocid
  vcn_id         = oci_core_vcn.default.id
  display_name   = "Public Subnet Security List"

  egress_security_rules {
    description      = "any egress"
    protocol         = local.transport_protocol_all
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }

  ingress_security_rules {
    description = "https ingress"
    protocol    = local.transport_protocol_tcp
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"

    tcp_options {
      min = 443
      max = 443
    }
  }

  # ingress_security_rules {
  #   description = "tailscale ipv4 ingress"
  #   protocol    = local.transport_protocol_udp
  #   source      = "0.0.0.0/0"
  #   source_type = "CIDR_BLOCK"
  #   stateless   = true

  #   udp_options {
  #     min = 41641
  #     max = 41641
  #   }
  # }
}

resource "oci_core_subnet" "public" {
  vcn_id                     = oci_core_vcn.default.id
  compartment_id             = var.oci_tenancy_ocid
  cidr_block                 = local.public_subnet_cidr
  availability_domain        = local.sydney_ad_name
  display_name               = "Public Subnet"
  dns_label                  = "public"
  security_list_ids          = [oci_core_security_list.public_subnet.id]
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_route_table_attachment" "public" {
  route_table_id = oci_core_route_table.public.id
  subnet_id      = oci_core_subnet.public.id
}

resource "oci_core_public_ip" "nat_gateway" {
  compartment_id = var.oci_tenancy_ocid
  lifetime       = "RESERVED"
  display_name   = "NAT Gateway Reserved Public IP"
}

resource "oci_core_nat_gateway" "default" {
  vcn_id         = oci_core_vcn.default.id
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Default NAT Gateway"
  block_traffic  = false
  public_ip_id   = oci_core_public_ip.nat_gateway.id
}

# resource "oci_core_service_gateway" "bastion" {
#   vcn_id         = oci_core_vcn.default.id
#   compartment_id = var.oci_tenancy_ocid

#   services {
#     service_id = "value"
#   }

#   services {
#     service_id = "value"
#   }
# }

resource "oci_core_route_table" "private" {
  vcn_id         = oci_core_vcn.default.id
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Private Route Table"

  route_rules {
    network_entity_id = oci_core_nat_gateway.default.id
    destination_type  = "CIDR_BLOCK"
    destination       = "0.0.0.0/0"
  }
}

resource "oci_core_security_list" "private_subnet" {
  compartment_id = var.oci_tenancy_ocid
  vcn_id         = oci_core_vcn.default.id
  display_name   = "Private Subnet Security List"

  egress_security_rules {
    description      = "any egress"
    protocol         = local.transport_protocol_all
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }

  # Reached only by traefik on grady, never by the NLB, so the source stays
  # inside the VCN. Widen this to 0.0.0.0/0 if a private instance ever becomes
  # an NLB backend — source preservation delivers the client's IP, not the
  # load balancer's, so there is no narrower CIDR that works.
  ingress_security_rules {
    description = "https ingress"
    protocol    = local.transport_protocol_tcp
    source      = local.vcn_cidr
    source_type = "CIDR_BLOCK"

    tcp_options {
      min = 443
      max = 443
    }
  }
}

resource "oci_core_subnet" "private" {
  vcn_id                     = oci_core_vcn.default.id
  compartment_id             = var.oci_tenancy_ocid
  cidr_block                 = local.private_subnet_cidr
  availability_domain        = local.sydney_ad_name
  display_name               = "Private Subnet"
  dns_label                  = "private"
  security_list_ids          = [oci_core_security_list.private_subnet.id]
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_route_table_attachment" "private" {
  route_table_id = oci_core_route_table.private.id
  subnet_id      = oci_core_subnet.private.id
}
