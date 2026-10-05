
output "grady_ip_address" {
  value = oci_core_instance.grady.public_ip
}

output "nlb_ip_address" {
  value = oci_core_public_ip.nlb.ip_address
}

output "aperture_load_balancer_ipv4_address" {
  value = oci_core_public_ip.aperture_load_balancer.ip_address
}

output "aperture_load_balancer_ipv6_address" {
  value = oci_core_ipv6.aperture_load_balancer.ip_address
}
