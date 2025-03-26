variable "pve_address" {
    description = "Address to connect to proxmox datacenter"
    type = string
}

variable "guest_name" {
    description = "Set the name of the new vm"
    type = string
}

variable "guest_id" {
    description = "Set the id of the new vm"
    type = number
}

variable "clone_id" {
    description = "Set the id for the target to clone from"
    type = number
}