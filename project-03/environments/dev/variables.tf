variable "ssh_public_key" {
  description = "SSH public key used to login to the VM"
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}


