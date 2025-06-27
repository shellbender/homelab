# ZFS prototype

## Summary
There are 4 stages to this:
1) Physical and OS setup
2) ZFS configuration
3) Proxmox configuration
4) VM configuration

## Physical and OS setup

Using RAID1 mirroring

## ZFS configuration

There are 3 lelvels of zfs.

Level 1 pool. This is setup of the devices using the zpool command.

Level 2 dataset tree. Uses zfs command. A pool can house multiple datasets.

Datasets are either filesystem or volume (treated as a block device with a fixed size).

Datasets are stored hierarchically in a tree.

Level 3 Dataset filesystems/volumes in pve

### zpool/zfs command examples 

Some examples from history:
zpool create -m /media/local-zfs local-zfs mirror /dev/sdb /dev/sdc -f
zpool status
zpool list -v
zfs list

zpool status
  pool: local-zfs
 state: ONLINE
  scan: resilvered 216K in 00:00:01 with 0 errors on Tue May 27 10:51:53 2025
config:

        NAME        STATE     READ WRITE CKSUM
        local-zfs   ONLINE       0     0     0
          mirror-0  ONLINE       0     0     0
            sdb     ONLINE       0     0     0
            sdc     ONLINE       0     0     0

errors: No known data errors

### Steps for creating zfs

#### RAID-1 Example

zpool create -f -o ashift=12 <pool> mirror <device1> <device2>

### References

https://pve.proxmox.com/wiki/ZFS_on_Linux
https://www.reddit.com/r/Proxmox/comments/jppohv/a_very_short_guide_into_how_proxmox_uses_zfs/
https://www.youtube.com/watch?v=oSD-VoloQag
## Proxmox configuration
### theory one
theory: While I have created a zfs pool and it appears that proxmox has created volumes as dataset, it is a unpartitioned device. I suspect to get the most value out of zfs, I should use it at the filesystem level.
test: Creating a new dataset and adding it to proxmox datacenter as a directory does not appear to work as I expected. As part of the 'add' through ui, I have to select the content types- none of which is just hosting a directory or files in a pass-through manner.

### theory two
theory: I add zfs to proxmox storage through the add > zfs selection. Once established as storage, I can host the fileserver's data disk on it. Meaning I will need to treat it as a traditional disk and partition it.

## VM configuration

### steps
lsblk
    looking for disks. in this case, vdb
OR
fdisk -l

fdisk /dev/vdb

(in fdisk tui)
n
       add a new partition
p
   primary (0 primary, 0 extended, 4 free)

<enter>
    partition num selection
<enter>
    first sector selection
<enter>
    last sector default selection

w
    write changes
(exit fdisk tui)

Format with filesystem
sudo mkfs.ext4 /dev/vdb1
