variable "vm_resources_list" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    disk          = number
    core_fraction = number
  }))
  default = [
    {
      vm_name       = "vm-1"
      cpu           = 2
      ram           = 4
      disk          = 1
      core_fraction = 20

    },
    {
      vm_name       = "vm-2"
      cpu           = 2
      ram           = 2
      disk          = 3
      core_fraction = 5
    },
  ]
  description = "There's list if dict's with VM resources"
}


resource "yandex_compute_instance" "vm_for_each" {
  # определим имена и ресурсы
  for_each = {
    for index, vm in var.vm_resources_list :
    vm.vm_name => vm
  }

  name        = each.value.vm_name
  platform_id = var.vm_maintenance_class
  hostname    = each.value.vm_name
  

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction

  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
  }

  metadata = {
    serial-port-enable = var.metadata_info.serial-port-enable
    ssh-keys           = local.ssh-key
  }
}

resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_image
}
