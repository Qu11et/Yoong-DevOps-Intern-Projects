variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

variable "public_ip_id" {
  description = "ID of the public IP"
  type        = string
}

variable "network_interface_name" {
  description = "Name of the network interface"
  type        = string
  default     = "nic-module-default"
}

