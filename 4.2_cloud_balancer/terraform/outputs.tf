/* output "private_vm" {
  value = {
      for vm in yandex_compute_instance_group.lamp-instance.instances :
        vm.hostname => vm

    }
    }
 */