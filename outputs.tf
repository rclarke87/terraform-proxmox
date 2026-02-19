output "vm_name" {
  value = proxmox_virtual_environment_vm.docker_host.name
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.docker_host.vm_id
}