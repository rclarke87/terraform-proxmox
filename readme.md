# terraform-proxmox

Infrastructure as Code for provisioning VMs on my Proxmox homelab using Terraform and the [bpg/proxmox](https://registry.terraform.io/providers/bpg/proxmox/latest/docs) provider.

## Overview

This project automates VM provisioning on my self-hosted Proxmox VE server. VMs are cloned from a pre-built Ubuntu 24.04 cloud-init template and configured with static IPs, DNS, and SSH key injection — all without touching the Proxmox UI.

This is part of my broader homelab infrastructure, which includes pfSense for routing/firewalling, Traefik as a reverse proxy, GitLab CE for version control, and a Dell R730 running Proxmox as the hypervisor.

## Stack

- **Terraform** — infrastructure provisioning
- **bpg/proxmox** v0.96.0 — Proxmox VE provider
- **Proxmox VE** — hypervisor
- **Ubuntu 24.04** cloud-init template — base image
- **cloud-init** — VM initialisation (networking, SSH keys)

## What it does

- Clones a VM from an existing Ubuntu 24.04 cloud-init template
- Configures CPU, memory, and disk
- Sets a static IP, gateway, and DNS via cloud-init
- Injects an SSH public key for passwordless access
- Enables the QEMU guest agent

## Prerequisites

- Proxmox VE with a cloud-init ready VM template
- Terraform >= 1.0
- An API token for a `root@pam` user (see [Authentication](#authentication))

## Usage

```bash
# Initialise providers
terraform init

# Preview changes
terraform plan

# Apply
terraform apply

# Destroy
terraform destroy
```

## Authentication

Credentials are kept out of version control. Create a `terraform.tfvars` file (already in `.gitignore`):

```hcl
proxmox_endpoint  = "https://<your-proxmox-ip>:8006/"
proxmox_api_token = "root@pam!terraform=<your-token-secret>"
```

To create the token on your Proxmox host:

```bash
pveum user token add root@pam terraform --privsep 0
```

## Lessons learned

This project involved migrating from the [telmate/proxmox](https://registry.terraform.io/providers/telmate/proxmox/latest) provider to bpg/proxmox. The two providers have completely different schemas — `proxmox_vm_qemu` becomes `proxmox_virtual_environment_vm`, the provider arguments are renamed, and cloud-init configuration moves into an `initialization` block.

Key gotchas encountered:

- The bpg provider requires `endpoint` not `pm_api_url`, and the API token is a single combined string (`user@realm!tokenid=secret`) rather than separate ID and secret fields
- API tokens for PVE realm users (`terraform@pve`) fail silently on clone operations despite having correct permissions — use a `root@pam` token instead
- Cloud-init gateway must match the VM's subnet — setting it to a gateway on a different subnet breaks return routing even though the VM appears to boot correctly
- Linked clones (`full = false`) require stricter permissions than full clones

## Project structure

```
.
├── main.tf           # Provider config and VM resource
├── variables.tf      # Variable declarations
├── outputs.tf        # VM name and ID outputs
├── terraform.tfvars  # Credentials and endpoint (gitignored)
└── .gitignore
```

## Part of

This repo is one piece of a wider homelab build documented at [spinstate.dev](https://spinstate.dev).