variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "network_interface_id" {
  description = "ID of the network interface to which the public IP will be associated"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key used to login to the VM"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "Username for the VM administrator"
  type        = string
}

variable "storage_account_type" {
  description = "Storage account type for the OS disk"
  type        = string
}

variable "publisher" {
  description = "Publisher of the OS image"
  type        = string
}

variable "offer" {
  description = "Offer of the OS image"
  type        = string
}

variable "sku" {
  description = "SKU of the OS image"
  type        = string
}

# variable "os_version" {
#   description = "Version of the OS image"
#   type        = string
# } //// please fix this