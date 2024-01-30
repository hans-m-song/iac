output "network_load_balancer_id" {
  value = oci_network_load_balancer_network_load_balancer.this.id
}

output "network_load_balancer_listener_ids" {
  value = { for name, listener in oci_network_load_balancer_listener.this : name => listener.id }
}

output "network_load_balancer_backend_set_ids" {
  value = { for name, backend_set in oci_network_load_balancer_backend_set.this : name => backend_set.id }
}

output "network_load_balancer_backend_ids" {
  value = { for name, backend in oci_network_load_balancer_backend.this : name => backend.id }
}
