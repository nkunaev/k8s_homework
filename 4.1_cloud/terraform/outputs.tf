output "private_vm" {

  value = {
    for index, vm in yandex_compute_instance.vm_for_each : index => ({
      hostname    = vm.hostname
      external_ip = vm.network_interface[0].nat_ip_address
      internal_ip = vm.network_interface[0].ip_address

    })
  }

}
