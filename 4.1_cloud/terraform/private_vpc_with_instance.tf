####################
# HOST DESCRIPTION #
####################
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
      vm_name       = "private-vm"
      cpu           = 2
      ram           = 4
      disk          = 15
      core_fraction = 20
    }
  ]
  description = "NAT insance description"
}

#####################
# IMAGE DESCRIPTION #
#####################

data "yandex_compute_image" "ubuntu2204" {
  family = var.vm_image
}

######################
# SUBNET DESCRIPTION #
######################

resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.my-network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

####################
# VM CONFIGURATION #
####################

resource "yandex_compute_instance" "vm_for_each" {

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
      image_id = data.yandex_compute_image.ubuntu2204.image_id
      size     = each.value.disk
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    security_group_ids = ["${yandex_vpc_security_group.default_security_group.id}"]
  }

  metadata = {
    serial-port-enable = var.metadata_info.serial-port-enable
    ssh-keys           = local.ssh-key
  }
}
