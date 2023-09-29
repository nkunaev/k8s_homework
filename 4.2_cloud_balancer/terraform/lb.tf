/* resource "yandex_lb_target_group" "lamp" {
  name      = "target-group"
  region_id = "ru-central1"

  dynamic "target" {
    for_each = yandex_compute_instance_group.lamp-instance.instance_template
    content {
      subnet_id = "${yandex_vpc_subnet.public.id}"
      address   = lookup(target.network_interface[0].value, "nat_ip_address", null)
    } 
  }
}

resource "yandex_lb_network_load_balancer" "my-lb" {
  name = "network-load-balancer"
  depends_on = [ yandex_compute_instance_group.lamp-instance ]

  listener {
    name = "listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_compute_instance_group.lamp-instance.id}"

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
} */