locals {
  oci = {
    availability_domain_ap_sydney_1    = "qTfi:AP-SYDNEY-1-AD-1"
    instance_image_ubuntu_2204_minimal = "ocid1.image.oc1.ap-sydney-1.aaaaaaaalnwwb6nxso6wn5fpjeee5jzty7scqdnjgqlvcootbvmbf4nuhamq"
    instance_shape_amd                 = "VM.Standard.E2.1.Micro"
    transport_protocol_all             = "all"
    transport_protocol_icmp            = "1"
    transport_protocol_tcp             = "6"
    transport_protocol_udp             = "17"
    transport_protocol_icmpv6          = "58"
  }
}

resource "oci_core_vcn" "default" {
  compartment_id = var.oci_tenancy_ocid
  cidr_blocks    = ["10.10.0.0/16"]
  dns_label      = "default"
  display_name   = "Default Virtual Cloud Network"
}

resource "oci_core_internet_gateway" "default" {
  vcn_id         = oci_core_vcn.default.id
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Default Internet Gateway"
}

resource "oci_core_route_table" "default" {
  vcn_id         = oci_core_vcn.default.id
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Default Route Table"

  route_rules {
    network_entity_id = oci_core_internet_gateway.default.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_security_list" "default" {
  compartment_id = var.oci_tenancy_ocid
  vcn_id         = oci_core_vcn.default.id
  display_name   = "Default Security List"

  ingress_security_rules {
    protocol    = local.oci.transport_protocol_all
    source      = "127.0.0.1/32"
    source_type = "CIDR_BLOCK"
  }

  egress_security_rules {
    protocol         = local.oci.transport_protocol_all
    destination      = "127.0.0.1/32"
    destination_type = "CIDR_BLOCK"
  }
}

# private

resource "oci_core_security_list" "private" {
  compartment_id = var.oci_tenancy_ocid
  vcn_id         = oci_core_vcn.default.id
  display_name   = "Public Security List"

  ingress_security_rules {
    protocol    = local.oci.transport_protocol_all
    source      = "10.10.0.0/16"
    source_type = "CIDR_BLOCK"
  }

  egress_security_rules {
    protocol         = local.oci.transport_protocol_all
    destination      = "10.10.0.0/16"
    destination_type = "CIDR_BLOCK"
  }
}

resource "oci_core_subnet" "private" {
  vcn_id                     = oci_core_vcn.default.id
  compartment_id             = var.oci_tenancy_ocid
  cidr_block                 = "10.10.0.0/24"
  availability_domain        = local.oci.availability_domain_ap_sydney_1
  display_name               = "Private Subnet"
  security_list_ids          = [oci_core_security_list.private.id]
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
}

# public

resource "oci_core_security_list" "public" {
  compartment_id = var.oci_tenancy_ocid
  vcn_id         = oci_core_vcn.default.id
  display_name   = "Public Security List"

  egress_security_rules {
    description      = "HTTP"
    protocol         = local.oci.transport_protocol_tcp
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"

    tcp_options {
      max = 80
      min = 80
    }
  }

  egress_security_rules {
    description      = "HTTPS"
    protocol         = local.oci.transport_protocol_tcp
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"

    tcp_options {
      max = 443
      min = 443
    }
  }

  egress_security_rules {
    description      = "ZeroTier"
    protocol         = local.oci.transport_protocol_udp
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"

    udp_options {
      max = 9993
      min = 9993
    }
  }
}

resource "oci_core_subnet" "public" {
  vcn_id                     = oci_core_vcn.default.id
  compartment_id             = var.oci_tenancy_ocid
  cidr_block                 = "10.10.10.0/24"
  availability_domain        = local.oci.availability_domain_ap_sydney_1
  display_name               = "Public Subnet"
  security_list_ids          = [oci_core_security_list.public.id]
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
}
