output "vms" {
  value = {
    for name, mod in module.vms :
    name => {
      vm_id      = mod.vm_id
      ip_address = mod.ip_address
    }
  }
}
