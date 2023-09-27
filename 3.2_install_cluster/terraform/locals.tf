locals {
  ssh-key = "kunaev:${file("~/.ssh/settings.pub")}"
}

#declare -a IPS=(51.250.8.47 158.160.57.248 158.160.62.147 158.160.59.237 158.160.55.249)