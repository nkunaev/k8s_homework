
##########################
# VM GROUP CONFIGURATION #
##########################

resource "yandex_kubernetes_node_group" "worker-instances" {
  name       = "worker-instances"
  cluster_id = yandex_kubernetes_cluster.k8s-regional.id
  version    = "1.26"

  instance_template {
    platform_id = "standard-v1"
    resources {
      core_fraction = 100
      memory        = 4
      cores         = 2
    }

    boot_disk {
      type = "network-ssd"
      size = 64
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      subnet_ids         = [yandex_vpc_subnet.public-zone-a.id]
      nat                = true
      security_group_ids = [yandex_vpc_security_group.default_security_group.id]
    }

    metadata = {
      ssh-keys = "kunaev:${file("~/.ssh/id_rsa.pub")}"
    }
  }

  scale_policy {
    auto_scale {
      initial = 3
      max     = 6
      min     = 3
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  deploy_policy {
    max_unavailable = 3
    max_expansion   = 3
  }
}
