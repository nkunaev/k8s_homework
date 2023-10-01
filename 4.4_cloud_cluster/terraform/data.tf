data "yandex_resourcemanager_folder" "default" {
  name = "default"
}

data "yandex_iam_service_account" "service-account" {
  name = "sa-terraform"
}

data "yandex_compute_image" "ubuntu2204" {
  family = "ubuntu-2204-lts"
}