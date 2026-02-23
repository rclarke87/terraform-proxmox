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

module "vms" {
  source   = "./modules/vm"
  for_each = local.hosts

  vm_id       = each.value.vm_id
  name        = each.key
  template_id = 9200

  # Merge defaults with overrides
  cores     = merge(local.default_spec, each.value).cores
  memory    = merge(local.default_spec, each.value).memory
  disk_size = merge(local.default_spec, each.value).disk_size

  bridge      = "vmbr0"
  ip_address  = each.value.ip_address
  gateway     = "192.168.2.1"
  dns_servers = ["192.168.2.1"]

  ssh_public_key = trimspace(file("~/.ssh/id_ed25519.pub"))
}

resource "local_file" "ansible_inventory" {
  filename = "../homelab-ansible/inventory/hosts.yml"

  content = templatefile("${path.module}/inventory.tmpl", {
    hosts = local.hosts
  })
}
