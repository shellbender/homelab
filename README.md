# homelab
## Summary
I want to set up a plex server to host content within our household. I want a Raspberry Pi system with a virtualization layer to host the plex (and likely supportive applications- Radar and Sonar).


Hardware- Raspberry Pi 5
OS- ???
Application- ProxMox
Container- Plex server (Jellyfin OSS)

Prox Mox seems to be a solution for virtualization both VMs and containers.

I want to deploy this with as much IaC and CaC as possible.
I want to be able to remotely manage the system from anywhere.
I want to be able to consume media on the local network

Setup bare-metal server (raspberry pi)
Uefi boot
Net booting?
client machine with a network boot option enabled in the BIOS or UEFI settings
Unfortunately, Wi-Fi is not supported by the Raspberry Pi’s network install functionality.
To use the network boot functionality on your Raspberry Pi 4, you must update the bootloader on your device to a compatible version.
“Headless boot” is just imaging the card from a different machine

## Status
I have successfully set up a raspberry pi with uefi and a proxmox iso. I have the procedure documented and several individual pieces of configuration to help with this process. I was able to ssh to the box and remote manage it.

However, the uefi process has disabled (or doesn’t support) the lan port on the pi. I have been unable to restore functionality to it through the debian os. I suspect this is possible, but I lack the correct knowledge to identify the issue and work to resolve it- it might be a firmware issue, but I don’t know how to find the right firmware and load it. It might be a driver issue, but I don’t know how to find the right drivers.

So, I’m going to return to the drawing board, and attempt a new install on the pi. I’m going to install raspberry pi os lite on the hardware, and then install proxmox afterward. I suspect this will be an easier process to install and configure with ansible.

## TODO
* Deal with cert warning when logging into proxmox webui

## Procedure
version: 2

Install Ansible
Install python3
Run scripts/setup_venv.sh

### Flash sd card
Download Raspberry Pi imager
Download the Raspberry Pi OS arm64 lit image. 2024-10-22-raspios-bookworm-arm64-lite.img
Select the image to install, and set the options as desired.
    * Include enabling ssh
    * Include an accout
    * Configure wifi

### Bare metal configuration
Boot the device and log in
connect to wifi
check ip and hostname.

Run configure-proxmox_node.yml to execute those following installation instructions: https://github.com/jiangcuo/Proxmox-Port/wiki/Install-Proxmox-VE-on-Debian-bookworm

I am reviewing the following wiki for add'l installation steps: https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_12_Bookworm

#### Requirements
* Static IPs

#### Next Steps
Trying to figure out user access

The below steps have be added to configure_proxmox_node.yml and a new role

#### Proxmox CLI warnings
Seeing local warnings when running pveum on pve node

#### User creation
Run add_proxmox_user.yml
I need to do additional checking to make this idempotent, and then create groups with assigned roles

### Turn on lan port, disable wireless
Plug in the raspberry pi to a router
Run set_proxmox_wired.yml
If connection problems are encountered, restart the raspberry pi

### Proxmox VE configuration
Add a global admin group, a user, and assign user to group with add_proxmox_user.yml and add_proxmox_group.yml

### Adding jellyfin lxc
see https://tteck.github.io/Proxmox/ and https://www.reddit.com/r/Proxmox/comments/186qgqw/confused_with_the_best_way_to_run_plex_and_serve/

### Container Template Test
I'm following a YT guide and it's adding a container. One item I noticed is that it requires a bridge. A default bridge was setup on the proxmox iso, but not with a debian install.

I've taken several docs and converted it to ansible nmcli. It's being detected (and working) at the console/ssh nmcli/ip link. However, it does not appear in the proxmox gui. I suspect this is because proxmox is relying on /etc/network/interfaces config file.

Removing nmcli worked, and I'm templating /etc/network/interfaces. This appears to have resolved the problem.

Making some containers fails. Investigating why. ... The answer was because several of the available images are for amd64 architecture. No issue when trying multiple arm64 images

### Container IaC
We're going to start with Packer > Terraform > Ansible. It seems like this is the general "starting point" recommendation.

For this initial run, I'm wondering if I'll need Packer. Since it's a core item in the recommendation, I'm going to attempt to use it and then determine from there.

### Packer
Use create_token role to generate an api key to plug into credentials.pkr.hcl

#### Packer generate iso
Create a credentials file and a packer file. Then run `packer init ./[template]` and `packer validate -var-file "../credentials.pkr.hcl" ./template`

When ready, run packer build -var-file "../credentials.pkr.hcl" ./proxmox-ubuntu.pkr.hcl
Currently, hanging on 'Waiting for SSH to become available...'

The http server Packer creates was unaccessible by pve.
From the development machine I added a firewall port, then wget the target from pve.
firewall-cmd --list-all
sudo firewall-cmd --zone home --add-port=8802/tcp --permanent
sudo firewall-cmd --reload
firewall-cmd --set-default-zone=home
sudo firewall-cmd --list-all

In addition to opening up the port, I had to update the target BIOS to OVMF (UEFI), and configure the cloud-init with a hashed password.

### Cloud-Init VM
Cloned vms fails to boot with error: ()
Use of uninitialized value in split at /usr/share/perl5/PVE/QemuServer/Cloudinit.pm line 105.
generating cloud-init ISO
kvm: -device ide-cd,bus=ide.1,unit=0,drive=drive-ide2,id=ide2: Bus 'ide.1' not found
TASK ERROR: start failed: QEMU exited with code 1

> This is an easy fix IDE drivers are not avaivable on the pi so delete your ide-cdrom and readd it as scsi-cd, then it should start up. Hope I could help.

To change this behavior, update the packer file:
cloud_init_disk_type = "scsi"

### Packer generate OCI image
Reading through packer's LXC Builder docs, the requirements are a modern kernel and lxc package. Seems like a good opportunity to set up a builder vm to achieve this.

### SPECIAL NOTICE
* You may see the following error on the proxmox node when logged in as a non-root user.
> ipcc_send_rec[1] failed: Unknown error -1
> ipcc_send_rec[2] failed: Unknown error -1
> ipcc_send_rec[3] failed: Unknown error -1
> Unable to load access control list: Unknown error -1
* The cli is intended for use with the root user.
