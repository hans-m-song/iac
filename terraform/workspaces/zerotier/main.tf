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
    accept ipprotocol tcp and dport 139;  # samba
    accept ipprotocol tcp and dport 443;  # https
    accept ipprotocol tcp and dport 445;  # samba
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

resource "zerotier_member" "chell" {
  name                    = "chell"
  description             = "Managed by Terraform - Lenovo X1 Carbon G6"
  member_id               = "d82b83bd57"
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
  ip_assignments          = ["10.0.0.11"]
}

# resource "zerotier_member" "barney" {
#   name                    = "barney"
#   description             = "Managed by Terraform - Lenovo X1 Carbon G6"
#   member_id               = "TODO"
#   network_id              = zerotier_network.apeture.id
#   authorized              = true
#   allow_ethernet_bridging = false
#   ip_assignments          = ["10.0.0.12"]
# }

resource "zerotier_member" "alyx" {
  name                    = "alyx"
  description             = "Managed by Terraform - Apple MacBook Pro 2023"
  member_id               = "daedeb7943"
  network_id              = zerotier_network.apeture.id
  authorized              = true
  allow_ethernet_bridging = false
  ip_assignments          = ["10.0.0.13"]
}

resource "zerotier_member" "lamarr" {
  name                    = "lamarr"
  description             = "Managed by Terraform - Apple Mac Mini 2024"
  member_id               = "4ed04a030c"
  network_id              = zerotier_network.apeture.id
  authorized              = true
  allow_ethernet_bridging = false
  ip_assignments          = ["10.0.0.14"]
}

resource "zerotier_member" "gman" {
  name                    = "gman"
  description             = "Managed by Terraform - Dell Wyse 5070"
  member_id               = "d8f15af653"
  network_id              = zerotier_network.apeture.id
  authorized              = true
  allow_ethernet_bridging = false
  ip_assignments          = ["10.0.0.41"]
}

resource "zerotier_member" "wheatley" {
  name                    = "wheatley"
  description             = "Managed by Terraform - Dell Optiplex 9020 USFF"
  member_id               = "0e5a4e81e7"
  network_id              = zerotier_network.apeture.id
  authorized              = true
  allow_ethernet_bridging = false
  ip_assignments          = ["10.0.0.42"]
}

resource "zerotier_member" "glados" {
  name                    = "glados"
  description             = "Managed by Terraform - Lenovo ThinkCentre M710Q Tiny"
  member_id               = "8c409a32c5"
  network_id              = zerotier_network.apeture.id
  authorized              = true
  allow_ethernet_bridging = false
  ip_assignments          = ["10.0.0.43"]
}

# resource "zerotier_member" "vance" {
#   name                    = "vance"
#   description             = "Managed by Terraform - OCI AMD Compute Instance"
#   member_id               = "f6f03fbd26"
#   network_id              = zerotier_network.apeture.id
#   authorized              = true
#   allow_ethernet_bridging = false
#   ip_assignments          = ["10.0.0.100"]
# }
