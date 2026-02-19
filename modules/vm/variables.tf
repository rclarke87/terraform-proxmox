variable "vm_id" {
  type = number
}

variable "name" {
  type = string
}

variable "cores" {
  type = number
}

variable "memory" {
  type = number
}

variable "disk_size" {
  type = number
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "ip_address" {
  type = string
}

variable "gateway" {
  type = string
}

variable "dns_servers" {
  type = list(string)
}

variable "ssh_public_key" {
  type = string
}

variable "template_id" {
  type = number
}

variable "full_clone" {
  type    = bool
  default = false
}