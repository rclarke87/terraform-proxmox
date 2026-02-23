locals {
  default_spec = {
    cores     = 2
    memory    = 4096
    disk_size = 20
  }

  hosts = {
    docker01 = {
      vm_id      = 200
      ip_address = "192.168.2.50/24"
      tier       = "docker"
    }

    gitlab-host = {
      vm_id      = 201
      ip_address = "192.168.2.51/24"
      tier       = "docker"

      cores     = 4
      memory    = 8192
      disk_size = 40
    }

    monitor01 = {
      vm_id      = 210
      ip_address = "192.168.2.60/24"
      tier       = "monitoring"
    }
  }
}
