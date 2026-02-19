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

module "docker_host" {
  source = "./modules/vm"

  vm_id          = 200
  name           = "docker-host"
  template_id    = 9200
  cores          = 2
  memory         = 4096
  disk_size      = 20

  bridge         = "vmbr0"
  ip_address     = "192.168.2.50/24"
  gateway        = "192.168.2.1"
  dns_servers    = ["192.168.2.1"]

  ssh_public_key = trimspace(file(pathexpand("~/.ssh/id_ed25519.pub")))
}

module "gitlab" {
  source = "./modules/vm"

  vm_id          = 201
  name           = "gitlab"
  template_id    = 9200
  cores          = 2
  memory         = 4096
  disk_size      = 20

  bridge         = "vmbr0"
  ip_address     = "192.168.2.51/24"
  gateway        = "192.168.2.1"
  dns_servers    = ["192.168.2.1"]

  ssh_public_key = trimspace(file(pathexpand("~/.ssh/id_ed25519.pub")))
}