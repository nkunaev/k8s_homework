locals {
  ssh-key = "kunaev:${file("~/.ssh/settings.pub")}"
}


###metadata
variable "metadata_info" {
  default = {
    serial-port-enable = 1
  }
  type = object({
    serial-port-enable = number
  })
}

###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "my-network"
  description = "VPC network&subnet name"
}

variable "vm_image" {
  type        = string
  default     = "ubuntu-2204-lts"
  description = "https://cloud.yandex.ru/marketplace?categories=os"
}

variable "vm_maintenance_class" {
  type        = string
  default     = "standard-v1"
  description = "https://cloud.yandex.ru/docs/compute/concepts/vm-platforms"
}
