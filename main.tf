terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.96.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true
}

resource "proxmox_virtual_environment_vm" "docker_host" {
  name      = "tf-test"
  node_name = "proxmox"
  vm_id     = 200

  clone {
    vm_id = 9200
    full  = false
  }

  scsi_hardware = "virtio-scsi-pci"

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 20
    discard      = "on"
    iothread     = false
  }

  initialization {
    datastore_id = "local-lvm"

    ip_config {
      ipv4 {
        address = "192.168.2.50/24"
        gateway = "192.168.2.1"
      }
    }

    dns {
      servers = ["192.168.2.1"]
    }

    user_account {
      keys = [trimspace(file(pathexpand("~/.ssh/id_ed25519.pub")))]
    }
  }

  network_device {
    model  = "virtio"
    bridge = "vmbr0"
  }

  agent {
    enabled = true
    timeout = "2m"
  }
}