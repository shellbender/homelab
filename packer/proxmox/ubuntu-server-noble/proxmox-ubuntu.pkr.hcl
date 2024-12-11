
packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

# Variable Definitions
variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "proxmox_node" {
    type = string
}

variable "proxmox_vm_id" {
    type = string
}

variable "proxmox_vm_name" {
    type = string
}

variable "proxmox_ssh_user" {
    type = string
}

variable "proxmox_ssh_pass" {
    type = string
}

source "proxmox-iso" "ubuntu-server-noble" {
  # Proxmox Connection Settings
  proxmox_url = "${var.proxmox_api_url}"
  username = "${var.proxmox_api_token_id}"
  token = "${var.proxmox_api_token_secret}"
  insecure_skip_tls_verify = true

  # VM General Settings
  node = "${var.proxmox_node}"
  vm_id = "${var.proxmox_vm_id}"
  vm_name = "${var.proxmox_vm_name}"
  template_description = "Ubuntu Server Image"

  # VM OS Settings
  # (Option 1) Local ISO File
  // iso_file = "local:iso/debian-12.8.0-arm64-netinst.iso"
  // iso_file = "local:debian-12.8.0-arm64-netinst.iso"
  # - or -
  # (Option 2) Download ISO
  // iso_url = "https://releases.ubuntu.com/24.04/ubuntu-24.04-live-server-amd64.iso"
  // iso_checksum = "8762f7e74e4d64d72fceb5f70682e6b069932deedb4949c6975d0f0fe0a91be3"

  boot_iso {
    type = "scsi"
    iso_file = "local:iso/ubuntu-24.10-live-server-arm64.iso"
    iso_checksum = "8762f7e74e4d64d72fceb5f70682e6b069932deedb4949c6975d0f0fe0a91be3"
    unmount = true
  }

  // iso_storage_pool = "local"
  // unmount_iso = true

  // image  = "ubuntu:jammy"
  // commit = true

  # VM System Settings
  qemu_agent = true

  # VM Hard Disk Settings
  scsi_controller = "virtio-scsi-pci"

  disks {
      disk_size = "10G"
      format = "raw"
    //   storage_pool = "local-lvm"
      storage_pool = "local"
      // storage_pool_type = "lvm"
      type = "virtio"
  }

  # VM CPU Settings
  cores = "2"
  cpu_type = "host"

  # VM Memory Settings
  memory = "2048"

  # VM Network Settings
  // network_adapters {
  //     model = "virtio"
  //     bridge = "vmbr0"
  //     firewall = "false"
  // }

  // vm_interface = "net0"
  # VM Cloud-Init Settings
  cloud_init = true
  cloud_init_storage_pool = "local"

  # PACKER Boot Commands
  boot_command = [
      "<esc><wait>",
      "e<wait>",
      "<down><down><down><end>",
      "<bs><bs><bs><bs><wait>",
      "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
      "<f10><wait>"
  ]

  boot                    = "c"
  boot_wait               = "10s"
  communicator            = "ssh"

  # PACKER Autoinstall Settings
  http_directory          = "http"
  # (Optional) Bind IP Address and Port
  # http_bind_address       = "0.0.0.0"
  # http_port_min           = 8802
  # http_port_max           = 8802

  // ssh_username            = "ubuntu"
  ssh_username = "${var.proxmox_ssh_user}"

  # (Option 1) Add your Password here
  ssh_password = "${var.proxmox_ssh_pass}"
  # - or -
  # (Option 2) Add your Private SSH KEY file here
  // ssh_private_key_file    = "~/.ssh/id_ed25519_shellbender_underhill"

  # Raise the timeout, when installation takes longer
  ssh_timeout             = "30m"
  ssh_pty                 = true
}

# Build Definition to create the VM Template
build {

    name = "ubuntu-server-noble-iso"
    sources = ["source.proxmox-iso.ubuntu-server-noble"]

    // # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    // provisioner "shell" {
    //     inline = [
    //         "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
    //         "sudo rm /etc/ssh/ssh_host_*",
    //         "sudo truncate -s 0 /etc/machine-id",
    //         "sudo apt -y autoremove --purge",
    //         "sudo apt -y clean",
    //         "sudo apt -y autoclean",
    //         "sudo cloud-init clean",
    //         "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
    //         "sudo rm -f /etc/netplan/00-installer-config.yaml",
    //         "sudo sync"
    //     ]
    // }

    // # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    // provisioner "file" {
    //     source = "files/99-pve.cfg"
    //     destination = "/tmp/99-pve.cfg"
    // }

    // # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    // provisioner "shell" {
    //     inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    // }

    // # Add additional provisioning scripts here
    // # ...
}