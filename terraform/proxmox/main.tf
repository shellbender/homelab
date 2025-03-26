terraform {
  required_providers {
    # https://registry.terraform.io/providers/bpg/proxmox/latest
    proxmox = {
        source = "bpg/proxmox"
        version = "0.71.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "4.6.0"
    }
  }
}

provider "vault" {
  # Configuration options
}

data "vault_kv_secret_v2" "pve_creds" {
  name = "pve_creds"
  mount = "secret"
}

data "vault_kv_secret_v2" "cloud_init_creds" {
  name = "cloud_init_creds"
  mount = "secret"
}

provider "proxmox" {
  endpoint = var.pve_address

  username = data.vault_kv_secret_v2.pve_creds.data.username
  password = data.vault_kv_secret_v2.pve_creds.data.password

  # because self-signed TLS certificate is in use
  insecure = true

  ssh {
    agent = true
  }
}

resource "proxmox_virtual_environment_vm" "rhel_clone" {
  name = var.guest_name
  node_name = "hillhouse"
  vm_id = var.guest_id
  tags = ["rhel", "terraform"]


  clone {
    vm_id = var.clone_id
  }

  bios = "ovmf"

  initialization {
    datastore_id = "local"
    user_account {
      username = data.vault_kv_secret_v2.cloud_init_creds.data.username
      password = data.vault_kv_secret_v2.cloud_init_creds.data.password
      keys = [
          trimspace(data.vault_kv_secret_v2.cloud_init_creds.data.private_key)
      ]
    }
  }
}