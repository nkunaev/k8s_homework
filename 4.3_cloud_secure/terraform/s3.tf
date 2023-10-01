#Создаем пользователя для просмотра S3

resource "yandex_iam_service_account" "db-editor" {
  name = "db-editor"
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
  member    = "serviceAccount:${yandex_iam_service_account.db-editor.id}"
  depends_on = [ yandex_iam_service_account.db-editor ]
}


# Создаем ключ доступа для сервисной учетки 
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = "${yandex_iam_service_account.db-editor.id}"
  depends_on = [ yandex_iam_service_account.db-editor ]
  description        = "static access key for object storage"
}

# Создаем симметричный ключ шифрования 
resource "yandex_kms_symmetric_key" "s3-key" {
  name              = "s3-symetric-key"
  description       = "homework key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // equal to 1 year
}


#Колдуем S3
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "netology-kunaev-s3"
  depends_on = [ yandex_iam_service_account_static_access_key.sa-static-key, yandex_kms_symmetric_key.s3-key ]

   server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.s3-key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  anonymous_access_flags {
    read = true
    list = false
    config_read = true
  }
  
}
