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

# proxmox_api_url = "https://192.168.0.2:8006/api2/json"
# proxmox_api_token_id = "packer@pve!packer"
# proxmox_api_token_secret = "8b7de8b2-a1da-4e15-a34a-7f1d4651e868"

  # TODO: use terraform variable or remove the line, and use PROXMOX_VE_USERNAME environment variable
  username = "packer@pve"
  # TODO: use terraform variable or remove the line, and use PROXMOX_VE_PASSWORD environment variable
  password = "goldenboy"

  # because self-signed TLS certificate is in use
  insecure = true
  # uncomment (unless on Windows...)
  # tmp_dir  = "/var/tmp"

  ssh {
    agent = true
    # TODO: uncomment and configure if using api_token instead of password
    # username = "root"
  }
}

resource "proxmox_virtual_environment_vm" "rhel_clone" {
  name = "rhel-clone"
  node_name = "hillhouse"

  clone {
    vm_id = 161
  }

  agent  {
    enabled = true
  }

  memory {
    dedicated = 768
  }

  efi_disk {
    datastore_id = "local-lvm"
    file_format = "raw"
    type = "4m"
    # pre_enrolled_keys = false
  }

  # initialization {
  #   dns {
  #     servers = ["1.1.1.1"]
  #   }
  #   ip_config {
  #     ipv4 {
  #       address = "dhcp"
  #     }
  #   }
  # }
}

# output "vm_ipv4_address" {
#   value = proxmox_virtual_environment_vm.rhel_clone.ipv4_addresses[1][0]
# }