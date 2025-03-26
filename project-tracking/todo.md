* setup a selfrunner with github

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
    <!-- * Download from https://repo.jellyfin.org/files/server/linux/latest-stable/arm64-musl/jellyfin_10.10.6-arm64-musl.tar.gz -->
    * need wget, need htop
    * Through package manager
        * Add EPEL
            * sudo subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms && sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
            * sudo dnf install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm
sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm
            * sudo dnf install jellyfin
            * sudo systemctl enable --now jellyfin
            * sudo firewall-cmd --permanent --add-port 8096/tcp
            * sudo firewall-cmd --permanent --add-port 8920/tcp
            * sudo firewall-cmd --permanent --add-port 1900/udp
            * sudo firewall-cmd --permanent --add-port 7359/udp
            * sudo firewall-cmd --reload
            * Access through http://<ip-address>:8096
                * https will fail without a correct certificate
            * Go through web setup
                user: jellyfin
                password: 
            * Add a folder
            * The jellyfin service account needs access to this folder (group add seems fine)