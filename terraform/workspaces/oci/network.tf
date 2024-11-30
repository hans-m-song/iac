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

  ingress_security_rules {
    protocol    = local.transport_protocol_all
    source      = local.public_subnet_cidr
    source_type = "CIDR_BLOCK"
  }

  egress_security_rules {
    protocol         = local.transport_protocol_all
    destination      = local.public_subnet_cidr
    destination_type = "CIDR_BLOCK"
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

resource "oci_core_route_table" "private" {
  vcn_id         = oci_core_vcn.default.id
  compartment_id = local.compartment_id
  display_name   = "Private Route Table"

  route_rules {
    network_entity_id = local.natgw_private_ip_id
    destination_type  = "CIDR_BLOCK"
    destination       = "0.0.0.0/0"
  }
}

resource "oci_core_security_list" "private_subnet" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.default.id
  display_name   = "Private Subnet Security List"

  ingress_security_rules {
    protocol    = local.transport_protocol_all
    source      = local.private_subnet_cidr
    source_type = "CIDR_BLOCK"
  }

  egress_security_rules {
    protocol         = local.transport_protocol_all
    destination      = local.private_subnet_cidr
    destination_type = "CIDR_BLOCK"
  }
}

resource "oci_core_subnet" "private" {
  vcn_id                     = oci_core_vcn.default.id
  compartment_id             = local.compartment_id
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
