resource "yandex_lb_target_group" "lamp" {
  name      = "lamp-group"
  region_id = "ru-central1"

  dynamic "target" {
    for_each = [for s in yandex_compute_instance_group.lamp-instance.instances : {
      address = s.network_interface.0.ip_address
      subnet_id = s.network_interface.0.subnet_id
    }]

    content {
      subnet_id = target.value.subnet_id
      address   = target.value.address
    }
  }
}

resource "yandex_lb_network_load_balancer" "my-lb" {
  name = "network-load-balancer"
  depends_on = [ yandex_compute_instance_group.lamp-instance, yandex_lb_target_group.lamp ]

  listener {
    name = "listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_lb_target_group.lamp.id}"

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}