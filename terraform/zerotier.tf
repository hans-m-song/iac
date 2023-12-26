resource "zerotier_network" "apeture" {
  name        = "apeture"
  description = "Managed by Terraform"
  private     = true

  route {
    target = "10.0.0.0/16"
  }

  assignment_pool {
    start = "10.0.0.1"
    end   = "10.0.0.254"
  }

  flow_rules = <<-EOT
    # Allow only IPv4, IPv4 ARP, and IPv6 Ethernet frames.
    drop
      not ethertype ipv4
      and not ethertype arp
      and not ethertype ipv6
    ;

    # Drop non-ZeroTier issued and managed IP addresses.
    #
    # This prevents IP spoofing but also blocks manual IP management at the OS level and
    # bridging unless special rules to exempt certain hosts or traffic are added before
    # this rule.
    drop
      not chr ipauth
    ;

    # Allow only specific ports
    accept ipprotocol tcp and dport 22;   # ssh
    accept ipprotocol tcp and dport 443;  # http
    accept ipprotocol tcp and dport 6443; # kubeapi
    accept ipprotocol tcp and dport 2049; # nfs

    # Drop TCP SYN,!ACK packets (new connections) not explicitly whitelisted above
    #
    # TCP SYN (TCP flags will never match non-TCP packets)
    drop
      chr tcp_syn
      and not chr tcp_ack
    ;

    # Accept anything else. This is required since default is 'drop'.
    accept;
  EOT
}

resource "zerotier_member" "wheatley" {
  name                    = "wheatley"
  description             = "Managed by Terraform - Dell Optiplex 9020 USFF"
  member_id               = "253ddd04a8"
  network_id              = zerotier_network.apeture.id
  authorized              = true
  allow_ethernet_bridging = false
  ip_assignments          = ["10.0.0.42"]
}

resource "zerotier_member" "glados" {
  name                    = "glados"
  description             = "Managed by Terraform - Lenovo ThinkCentre M710Q Tiny"
  member_id               = "d6475fe97d"
  network_id              = zerotier_network.apeture.id
  authorized              = true
  allow_ethernet_bridging = false
  ip_assignments          = ["10.0.0.43"]
}

resource "zerotier_member" "chell" {
  name                    = "chell"
  description             = "Managed by Terraform - Apple MacBook Pro 2020"
  member_id               = "c6f7862584"
  network_id              = zerotier_network.apeture.id
  authorized              = true
  allow_ethernet_bridging = false
  ip_assignments          = ["10.0.0.10"]
}

resource "zerotier_member" "freeman" {
  name                    = "freeman"
  description             = "Managed by Terraform - Apple MacBook Pro 2014"
  member_id               = "806d5a0c51"
  network_id              = zerotier_network.apeture.id
  authorized              = true
  allow_ethernet_bridging = false
  ip_assignments          = ["10.0.0.20"]
}

# resource "zerotier_member" "barney" {
#   name                    = "barney"
#   description             = "Managed by Terraform - Lenovo X1 Carbon G6"
#   member_id               = "TODO"
#   network_id              = zerotier_network.apeture.id
#   authorized              = true
#   allow_ethernet_bridging = false
#   ip_assignments          = ["10.0.0.30"]
# }
