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

## Procedure
Install Ansible
Install python3
Run scripts/setup_venv.sh

### Install uefi5
Following https://github.com/worproject/rpi5-uefi/blob/v0.3/README.md#getting-started
# Flash the firmware
Run the partition_sd_card.yml ansible playbook
CAUTON: The proxmox iso will overwrite the entire disk (including the flashed uefi partition) during its installation.
Instead, I have flashed the uefi to a external hard drive. This allows RPi5 to boot, but the sd card (the proxmox install target) will not be mounted

Boot the Device
Confirms it reaches the bootloader menu

Proxmox installation
following https://github.com/jiangcuo/Proxmox-Port?tab=readme-ov-file
Download the iso

Execute the following command in your terminal, selecting the iso and a flash drive
sudo dd bs=4M if=~/downloads/proxmox-ve_8.2-4_arm64.iso of=/dev/sdg conv=fdatasync status=progress

## Install to RPi5
Select the flash drive from the bootmanager

Once in the installer, selecte Proxmox with Kernel 6.1
Select the sd card as the installation target.
I also adjusted the max size down ~5 GiB. There were threads online specificing that max size had led to problems

naming strategy: node01.hillhouse.local

When completed, it will fail to boot successfully
## Overwrite the <new> ESP partition
Shut down the RPi5, remove the sd card, and connect it to your machine.
Run replace_boot_part.yml, target the sd card device, and the partition labeled "EFI System Partition" in YaST2 partitioner. My configuration had this set to 1.00 GiB