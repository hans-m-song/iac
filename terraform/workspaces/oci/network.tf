resource "oci_core_vcn" "default" {
  compartment_id = local.compartment_id
  cidr_blocks    = [local.vcn_cidr]
  dns_label      = "default"
  display_name   = "Default Virtual Cloud Network"
}

resource "oci_core_internet_gateway" "default" {
  vcn_id         = oci_core_vcn.default.id
  compartment_id = local.compartment_id
  display_name   = "Default Internet Gateway"
}

resource "oci_core_route_table" "public" {
  vcn_id         = oci_core_vcn.default.id
  compartment_id = local.compartment_id
  display_name   = "Public Route Table"

  route_rules {
    network_entity_id = oci_core_internet_gateway.default.id
    destination_type  = "CIDR_BLOCK"
    destination       = "0.0.0.0/0"
  }
}

resource "oci_core_security_list" "public_subnet" {
  compartment_id = local.compartment_id
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

  ingress_security_rules {
    description = "tailscale ipv4 ingress"
    protocol    = local.transport_protocol_udp
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = true

    udp_options {
      min = 41641
      max = 41641
    }
  }
}

resource "oci_core_subnet" "public" {
  vcn_id                     = oci_core_vcn.default.id
  compartment_id             = local.compartment_id
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
