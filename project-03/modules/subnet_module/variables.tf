variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network to which the subnet belongs"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "subnet-module-default"
}

variable "address_prefixes" {
  description = "List of address prefixes for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

# variable "security_group_id" {
#   description = "ID of the network security group to associate with the subnet"
#   type        = string
# }

