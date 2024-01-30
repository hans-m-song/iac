resource "oci_network_load_balancer_network_load_balancer" "this" {
  compartment_id = var.compartment_id
  display_name   = var.display_name
  subnet_id      = var.subnet_id
  is_private     = var.is_private
}

resource "oci_network_load_balancer_listener" "this" {
  for_each                 = var.backends
  name                     = each.key
  default_backend_set_name = each.key
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.this.id
  port                     = each.value.port
  protocol                 = each.value.protocol
}

resource "oci_network_load_balancer_backend_set" "this" {
  for_each                 = var.backends
  name                     = each.key
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.this.id
  policy                   = try(each.value.health_check.policy, "FIVE_TUPLE")

  health_checker {
    port               = each.value.port
    protocol           = each.value.protocol
    retries            = try(each.value.health_check.retries, null)
    timeout_in_millis  = try(each.value.health_check.timeout_in_millis, null)
    interval_in_millis = try(each.value.health_check.interval_in_millis, null)
  }
}

resource "oci_network_load_balancer_backend" "this" {
  for_each                 = var.backends
  backend_set_name         = each.key
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.this.id
  port                     = each.value.port
  ip_address               = each.value.ip_address
  target_id                = each.value.target_id
}
