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

#### Old steps
Save ssh connection on configuring workstation. Add the following to ~/.ssh/config
Host proxmox01
```
    HostName hillhouse
    User gelzibar
    IdentityFile ~/.ssh/id_ed25519
```
Get the key to the server
ssh-copy-id -i ~/.ssh/id_rsa.pub gelzibar@hillhouse

#### Proxmox CLI warnings
Seeing local warnings when running pveum on hillhouse

#### User creation
Run add_proxmox_user.yml
I need to do additional checking to make this idempotent, and then create groups with assigned roles