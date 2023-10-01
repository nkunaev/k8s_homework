
resource "yandex_vpc_network" "my-network" {
  name = var.vpc_name
}

######################################
# SUBNET DESCRIPTION \\ PRIVATE ZONE #
######################################

resource "yandex_vpc_subnet" "private-zone-a" {
  name           = "private-zone-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.my-network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

resource "yandex_vpc_subnet" "private-zone-b" {
  name           = "private-zone-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.my-network.id
  v4_cidr_blocks = ["192.168.21.0/24"]
}

resource "yandex_vpc_subnet" "private-zone-c" {
  name           = "private-zone-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.my-network.id
  v4_cidr_blocks = ["192.168.22.0/24"]
}

#####################################
# SUBNET DESCRIPTION \\ PUBLIC ZONE #
#####################################

resource "yandex_vpc_subnet" "public-zone-a" {
  name           = "public-zone-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.my-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "public-zone-b" {
  name           = "public-zone-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.my-network.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}

resource "yandex_vpc_subnet" "public-zone-c" {
  name           = "public-zone-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.my-network.id
  v4_cidr_blocks = ["192.168.12.0/24"]
}