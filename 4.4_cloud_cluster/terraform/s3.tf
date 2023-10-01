/* #Создаем пользователя для просмотра S3

resource "yandex_iam_service_account" "db-viewer" {
  name = "db-viewer"
  description = "User for viewing s3"
  folder_id = data.yandex_resourcemanager_folder.default.id
}

data "yandex_iam_service_account" "sa-terraform" {
  name = "sa-terraform"
}

#Назначаем соответствующую роль

resource "yandex_resourcemanager_folder_iam_member" "db-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.db-viewer.id}"
  depends_on = [ yandex_iam_service_account.db-viewer ]
}


# Создаем ключ доступа для сервисной учетки 
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = "${yandex_iam_service_account.db-viewer.id}"
  depends_on = [ yandex_iam_service_account.db-viewer ]
  description        = "static access key for object storage"
}

#Колдуем S3
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "netology-kunaev-s3"
  depends_on = [ yandex_iam_service_account_static_access_key.sa-static-key ]

  anonymous_access_flags {
    read = true
    list = false
    config_read = true
  }
  
}
 */