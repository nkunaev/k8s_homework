# Создаем симметричный ключ шифрования 
resource "yandex_kms_symmetric_key" "s3-key" {
  name              = "s3-symetric-key"
  description       = "homework key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // equal to 1 year
}
