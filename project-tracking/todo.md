* TODO - 0810 - Expand default storage on Hard Disk virtio0 from 10g to 20g as a base for vms.
    sudo dnf -y install cloud-utils-growpart
    growpart /dev/vda 3 -N # dry run
    growpart /dev/vda 3

    /dev/vda
    /dev/vda3
    
    sudo lvm
    # Confirm the sizing of physical volume
    pvs
    # Get the lv path
    lvdisplay
    # Extend
    lvextend -l +100%FREE /dev/rhel/root


Need to associate the 2T disk to a mount on fileserver

# OLD
* setup a selfrunner with github
* TODO - Can't take a snapshot. 'The current guest configuration does not support taking new snapshots'
* TODO - Automate the jellyfin post-install wizard

* NAS setup.
    * Physically connect the devices
    * install and configure raid at OS level
        * Edit /boot/firmware/config.txt and add dtparam=pciex1 to the end of the file, save and reboot.
        * Adding dtparam=pciex1_gen=3 to /boot/firmware/config.txt will force the Raspberry Pi 5 to use PCIe Gen 3.
        * Check drive health (per hdd): sudo smartctl -a /dev/sda | less
        * Add sudo apt update
        * sudo apt install mdadm
        * make raid
            * lsblk
            * sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sda /dev/sdb
            * sudo mkfs.ext4 /dev/md0
            * sudo mkdir /mnt/raid1
            * sudo mount /dev/md0 /mnt/raid1
    * Setup in proxmox
    * Passthrough to device

* Jellyfin
    * Access through http://<ip-address>:8096
        * https will fail without a correct certificate
    * Go through web setup
        user: jellyfin
        password: 
    * Add a folder
    * The jellyfin service account needs access to this folder (group add seems fine)