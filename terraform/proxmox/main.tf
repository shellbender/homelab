terraform {
  required_providers {
    # https://registry.terraform.io/providers/bpg/proxmox/latest
    proxmox = {
        source = "bpg/proxmox"
        version = "0.71.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.0.2:8006/"


  # TODO: use terraform variable or remove the line, and use PROXMOX_VE_USERNAME environment variable
  username = "<username>"
  # TODO: use terraform variable or remove the line, and use PROXMOX_VE_PASSWORD environment variable
  password = "<password>"

  # because self-signed TLS certificate is in use
  insecure = true

  ssh {
    agent = true
  }
}

resource "proxmox_virtual_environment_vm" "rhel_clone" {
  name = "rhel-clone"
  node_name = "hillhouse"
  vm_id = 100

  clone {
    vm_id = 161
  }

  bios = "ovmf"

  efi_disk {
    datastore_id = "local"
    file_format = "raw"
    type = "4m"
  }

}