resource "yandex_iam_service_account" "k8s-editor" {
  name        = "k8s-editor"
  description = "User for edit k8s cluster"
  folder_id   = data.yandex_resourcemanager_folder.default.id
}

data "yandex_iam_service_account" "sa-terraform" {
  name = "sa-terraform"
}

#Назначаем соответствующую роль

resource "yandex_resourcemanager_folder_iam_member" "k8s-editor" {
  folder_id  = var.folder_id
  role       = "k8s.clusters.agent"
  member     = "serviceAccount:${yandex_iam_service_account.k8s-editor.id}"
  depends_on = [yandex_iam_service_account.k8s-editor]
}

resource "yandex_resourcemanager_folder_iam_member" "registry-puller" {
  folder_id  = var.folder_id
  role       = "container-registry.images.puller"
  member     = "serviceAccount:${yandex_iam_service_account.k8s-editor.id}"
  depends_on = [yandex_iam_service_account.k8s-editor]
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public" {
  folder_id  = var.folder_id
  role       = "vpc.publicAdmin"
  member     = "serviceAccount:${yandex_iam_service_account.k8s-editor.id}"
  depends_on = [yandex_iam_service_account.k8s-editor]
}

resource "yandex_resourcemanager_folder_iam_member" "viewer" {
  folder_id  = var.folder_id
  role       = "viewer"
  member     = "serviceAccount:${yandex_iam_service_account.k8s-editor.id}"
  depends_on = [yandex_iam_service_account.k8s-editor]
}

# Создаем ключ доступа для сервисной учетки 
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.k8s-editor.id
  depends_on         = [yandex_iam_service_account.k8s-editor]
  description        = "static access key for k8s cluster"
}


resource "yandex_kubernetes_cluster" "k8s-regional" {
  name       = "my-k8s-cluster"
  network_id = yandex_vpc_network.my-network.id
  master {
    version   = "1.26"
    public_ip = true
    regional {
      region = "ru-central1"
      location {
        zone      = yandex_vpc_subnet.public-zone-a.zone
        subnet_id = yandex_vpc_subnet.public-zone-a.id
      }
      location {
        zone      = yandex_vpc_subnet.public-zone-b.zone
        subnet_id = yandex_vpc_subnet.public-zone-b.id
      }
      location {
        zone      = yandex_vpc_subnet.public-zone-c.zone
        subnet_id = yandex_vpc_subnet.public-zone-c.id
      }
    }
    security_group_ids = [yandex_vpc_security_group.default_security_group.id]
  }
  service_account_id      = yandex_iam_service_account.k8s-editor.id
  node_service_account_id = yandex_iam_service_account.k8s-editor.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-editor,
    yandex_resourcemanager_folder_iam_member.registry-puller,
    yandex_resourcemanager_folder_iam_member.vpc-public,
    yandex_resourcemanager_folder_iam_member.viewer
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.s3-key.id
  }
}