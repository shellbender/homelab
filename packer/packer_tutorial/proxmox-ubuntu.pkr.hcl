
packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "debian" {
  # Proxmox Connection Settings
  proxmox_url = "${var.proxmox_api_url}"
  username = "${var.proxmox_api_token_id}"
  token = "${var.proxmox_api_token_secret}"
  # (Optional) Skip TLS Verification
  # insecure_skip_tls_verify = true

  # VM General Settings
  node = "your-proxmox-node"
  vm_id = "104"
  vm_name = "debian-server"
  template_description = "Debian Server Image"

  # VM OS Settings
  # (Option 1) Local ISO File
  // iso_file = "local:iso/debian-12.8.0-arm64-netinst.iso"
  iso_file = "local:debian-12.8.0-arm64-netinst.iso"
  # - or -
  # (Option 2) Download ISO
  # iso_url = "https://releases.ubuntu.com/24.04/ubuntu-24.04-live-server-amd64.iso"
  # iso_checksum = "8762f7e74e4d64d72fceb5f70682e6b069932deedb4949c6975d0f0fe0a91be3"
  iso_storage_pool = "local"
  unmount_iso = true


  image  = "ubuntu:jammy"
  commit = true
}

build {
  name    = "learn-packer"
  sources = [
    "source.docker.ubuntu"
  ]
}

boot_iso {
  # ide, sata, or scsi
  type = "scsi"
  iso_file = "local:iso/debian-12.5.0-amd64-netinst.iso"
  unmount = true
  iso_checksum = "sha512:33c08e56c83d13007e4a5511b9bf2c4926c4aa12fd5dd56d493c0653aecbab380988c5bf1671dbaea75c582827797d98c4a611f7fb2b131fbde2c677d5258ec9"
}