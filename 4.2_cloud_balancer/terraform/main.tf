#####################
# IMAGE DESCRIPTION #
#####################

data "yandex_compute_image" "lamp" {
  family = "lamp"
}

######################
# SUBNET DESCRIPTION #
######################

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.my-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

####################
# VM CONFIGURATION #
####################

resource "yandex_compute_instance_group" "lamp-instance" {
  name = "lamp"

  folder_id          = data.yandex_resourcemanager_folder.default.id
  service_account_id = data.yandex_iam_service_account.service-account.id

  deletion_protection = false
  instance_template {
    platform_id = "standard-v1"
    resources {
      core_fraction = 20
      memory        = 4
      cores         = 2
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.lamp.image_id
      }
    }
    scheduling_policy {
      preemptible = true
    }
    network_interface {
      subnet_ids          = ["${yandex_vpc_subnet.public.id}"]
      nat                = true
      security_group_ids = ["${yandex_vpc_security_group.default_security_group.id}"]
    }

    metadata = {
      ssh-keys = "kunaev:${file("~/.ssh/id_rsa.pub")}"
      user_data = file("${path.module}/main_page.sh")
    }

    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 3
    max_expansion   = 2
    max_deleting    = 3
  }
}
