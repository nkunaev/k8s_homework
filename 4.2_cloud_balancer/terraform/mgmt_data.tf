data "yandex_resourcemanager_folder" "default" {
  name = "default"
}

data "yandex_iam_service_account" "service-account" {
  name = "sa-terraform"
}