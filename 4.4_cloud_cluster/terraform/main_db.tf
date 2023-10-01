resource "yandex_mdb_mysql_cluster" "mysql-cluster" {
  name                = "my-db"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.my-network.id
  version             = "8.0"
  deletion_protection = false
  security_group_ids  = [yandex_vpc_security_group.default_security_group.id]

  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  host {
    zone             = "ru-central1-a"
    subnet_id        = yandex_vpc_subnet.private-zone-a.id
    assign_public_ip = false
  }

  host {
    zone             = "ru-central1-b"
    subnet_id        = yandex_vpc_subnet.private-zone-b.id
    assign_public_ip = false
  }

  host {
    zone             = "ru-central1-c"
    subnet_id        = yandex_vpc_subnet.private-zone-c.id
    assign_public_ip = false
  }
}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql-cluster.id
  name       = "netology_db"
}

resource "yandex_mdb_mysql_user" "db-user" {
  cluster_id = yandex_mdb_mysql_cluster.mysql-cluster.id
  name       = "awesome-user"
  password   = "awesome-password"
  permission {
    database_name = "netology_db"
    roles         = ["ALL"]
  }
}