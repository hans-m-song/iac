resource "oci_core_instance" "pbody" {
  availability_domain = local.sydney_ad_name
  compartment_id      = var.oci_tenancy_ocid
  display_name        = "pbody"
  shape               = local.amd_instance_shape_name

  agent_config {
    are_all_plugins_disabled = false

    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }

  create_vnic_details {
    assign_ipv6ip          = false
    assign_public_ip       = false
    display_name           = "pbody"
    hostname_label         = "pbody"
    nsg_ids                = [oci_core_network_security_group.aperture_application.id]
    private_ip             = local.pbody_private_ip
    skip_source_dest_check = false
    subnet_id              = oci_core_subnet.aperture_private.id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data = base64encode(templatefile("${path.module}/templates/aperture-app.cloud-init.yaml.tftpl", {
      instance_name = "pbody"
    }))
  }

  source_details {
    boot_volume_size_in_gbs = 50
    source_id               = local.amd_canonical_ubuntu_image_id
    source_type             = "image"
  }

  lifecycle {
    ignore_changes = [source_details[0].source_id]
  }
}

resource "oci_load_balancer_backend" "pbody" {
  backendset_name  = oci_load_balancer_backend_set.aperture.name
  backup           = false
  drain            = false
  ip_address       = oci_core_instance.pbody.private_ip
  load_balancer_id = oci_load_balancer_load_balancer.aperture.id
  offline          = false
  port             = 80
  weight           = 1
}
