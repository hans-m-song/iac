locals {
  aperture_vcn_cidr            = "10.42.0.0/16"
  aperture_public_subnet_cidr  = "10.42.0.0/27"
  aperture_private_subnet_cidr = "10.42.16.0/24"
  pbody_private_ip             = "10.42.16.10"
}

data "oci_core_services" "oracle_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_vcn" "aperture" {
  compartment_id                   = var.oci_tenancy_ocid
  cidr_blocks                      = [local.aperture_vcn_cidr]
  display_name                     = "Aperture VCN"
  dns_label                        = "aperture"
  is_ipv6enabled                   = true
  is_oracle_gua_allocation_enabled = true
}

resource "oci_core_security_list" "aperture" {
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Aperture Security List"
  vcn_id         = oci_core_vcn.aperture.id

  egress_security_rules {
    destination      = local.aperture_private_subnet_cidr
    destination_type = "CIDR_BLOCK"
    protocol         = local.transport_protocol_tcp
    stateless        = false

    tcp_options {
      max = 80
      min = 80
    }
  }

  egress_security_rules {
    destination      = local.aperture_private_subnet_cidr
    destination_type = "CIDR_BLOCK"
    protocol         = local.transport_protocol_tcp
    stateless        = false

    tcp_options {
      max = 22
      min = 22
    }
  }
}

resource "oci_core_internet_gateway" "aperture" {
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Aperture Internet Gateway"
  vcn_id         = oci_core_vcn.aperture.id
}

resource "oci_core_nat_gateway" "aperture" {
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Aperture NAT Gateway"
  vcn_id         = oci_core_vcn.aperture.id
}

resource "oci_core_route_table" "aperture_public" {
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Aperture Public Route Table"
  vcn_id         = oci_core_vcn.aperture.id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.aperture.id
  }

  route_rules {
    destination       = "::/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.aperture.id
  }
}

resource "oci_core_route_table" "aperture_private" {
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Aperture Private Route Table"
  vcn_id         = oci_core_vcn.aperture.id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.aperture.id
  }

  route_rules {
    destination       = data.oci_core_services.oracle_services.services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.aperture.id
  }
}

resource "oci_core_service_gateway" "aperture" {
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Aperture Service Gateway"
  vcn_id         = oci_core_vcn.aperture.id

  services {
    service_id = data.oci_core_services.oracle_services.services[0].id
  }
}

resource "oci_core_subnet" "aperture_public" {
  cidr_block                = local.aperture_public_subnet_cidr
  compartment_id            = var.oci_tenancy_ocid
  display_name              = "Aperture Public Subnet"
  dns_label                 = "public"
  ipv6cidr_block            = cidrsubnet(oci_core_vcn.aperture.ipv6cidr_blocks[0], 8, 0)
  prohibit_internet_ingress = false
  route_table_id            = oci_core_route_table.aperture_public.id
  security_list_ids         = [oci_core_security_list.aperture.id]
  vcn_id                    = oci_core_vcn.aperture.id
}

resource "oci_core_subnet" "aperture_private" {
  cidr_block                = local.aperture_private_subnet_cidr
  compartment_id            = var.oci_tenancy_ocid
  display_name              = "Aperture Private Subnet"
  dns_label                 = "private"
  prohibit_internet_ingress = true
  route_table_id            = oci_core_route_table.aperture_private.id
  security_list_ids         = [oci_core_security_list.aperture.id]
  vcn_id                    = oci_core_vcn.aperture.id
}

resource "oci_core_network_security_group" "aperture_load_balancer" {
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Aperture Load Balancer"
  vcn_id         = oci_core_vcn.aperture.id
}

resource "oci_core_network_security_group" "aperture_application" {
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Aperture Application"
  vcn_id         = oci_core_vcn.aperture.id
}

resource "oci_core_network_security_group_security_rule" "load_balancer_http_ipv4" {
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.aperture_load_balancer.id
  protocol                  = local.transport_protocol_tcp
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "load_balancer_http_ipv6" {
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.aperture_load_balancer.id
  protocol                  = local.transport_protocol_tcp
  source                    = "::/0"
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "load_balancer_to_application" {
  destination               = oci_core_network_security_group.aperture_application.id
  destination_type          = "NETWORK_SECURITY_GROUP"
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.aperture_load_balancer.id
  protocol                  = local.transport_protocol_tcp

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "application_http_from_vcn" {
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.aperture_application.id
  protocol                  = local.transport_protocol_tcp
  source                    = local.aperture_vcn_cidr
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "application_dns_udp" {
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.aperture_application.id
  protocol                  = local.transport_protocol_udp

  udp_options {
    destination_port_range {
      min = 53
      max = 53
    }
  }
}

resource "oci_core_network_security_group_security_rule" "application_dns_tcp" {
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.aperture_application.id
  protocol                  = local.transport_protocol_tcp

  tcp_options {
    destination_port_range {
      min = 53
      max = 53
    }
  }
}

resource "oci_core_network_security_group_security_rule" "application_ntp" {
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.aperture_application.id
  protocol                  = local.transport_protocol_udp

  udp_options {
    destination_port_range {
      min = 123
      max = 123
    }
  }
}

resource "oci_core_network_security_group_security_rule" "application_http" {
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.aperture_application.id
  protocol                  = local.transport_protocol_tcp

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "application_https" {
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.aperture_application.id
  protocol                  = local.transport_protocol_tcp

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

resource "oci_core_public_ip" "aperture_load_balancer" {
  compartment_id = var.oci_tenancy_ocid
  display_name   = "Aperture Load Balancer IPv4"
  lifetime       = "RESERVED"

  lifecycle {
    ignore_changes = [private_ip_id]
  }
}

resource "oci_core_ipv6" "aperture_load_balancer" {
  display_name = "Aperture Load Balancer IPv6"
  lifetime     = "RESERVED"
  subnet_id    = oci_core_subnet.aperture_public.id
}

resource "oci_load_balancer_load_balancer" "aperture" {
  compartment_id             = var.oci_tenancy_ocid
  display_name               = "Aperture Load Balancer"
  ip_mode                    = "IPV6"
  is_private                 = false
  network_security_group_ids = [oci_core_network_security_group.aperture_load_balancer.id]
  shape                      = "flexible"
  subnet_ids                 = [oci_core_subnet.aperture_public.id]

  reserved_ips {
    id = oci_core_public_ip.aperture_load_balancer.id
  }

  reserved_ips {
    id = oci_core_ipv6.aperture_load_balancer.id
  }

  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
}

resource "oci_load_balancer_backend_set" "aperture" {
  load_balancer_id = oci_load_balancer_load_balancer.aperture.id
  name             = "http"
  policy           = "ROUND_ROBIN"

  health_checker {
    interval_ms         = 10000
    port                = 80
    protocol            = "HTTP"
    response_body_regex = "healthy"
    retries             = 3
    return_code         = 200
    timeout_in_millis   = 3000
    url_path            = "/"
  }
}

resource "oci_load_balancer_listener" "aperture" {
  default_backend_set_name = oci_load_balancer_backend_set.aperture.name
  load_balancer_id         = oci_load_balancer_load_balancer.aperture.id
  name                     = "http"
  port                     = 80
  protocol                 = "HTTP"
}
