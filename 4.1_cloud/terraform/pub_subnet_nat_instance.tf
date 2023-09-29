#####################
# IMAGE DESCRIPTION #
#####################

data "yandex_compute_image" "nat_instance" {
  family = "nat-instance-ubuntu-2204"
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

#################
# ROUTING TABLE #
#################

resource "yandex_vpc_route_table" "nat-instance-route" {
  name       = "nat-instance-route"
  network_id = yandex_vpc_network.my-network.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat-instance.network_interface.0.ip_address
  }
}
####################
# VM CONFIGURATION #
####################

resource "yandex_compute_instance" "nat-instance" {
  name        = "nat-machine"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nat_instance.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = ["${yandex_vpc_security_group.default_security_group.id}"]
    ip_address         = "192.168.10.254"
  }

  metadata = {
    serial-port-enable = var.metadata_info.serial-port-enable
    ssh-keys           = local.ssh-key
  }
}

resource "yandex_compute_instance" "public-vm" {

  for_each = {
    for index, vm in var.vm_resources_list :
    vm.vm_name => vm
  }

  name        = "public-net-vm"
  platform_id = var.vm_maintenance_class
  hostname    = "public-net-vm"

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
    subnet_id          = yandex_vpc_subnet.public.id
    security_group_ids = ["${yandex_vpc_security_group.default_security_group.id}"]
    nat                = true
  }

  metadata = {
    serial-port-enable = var.metadata_info.serial-port-enable
    ssh-keys           = local.ssh-key
  }
}