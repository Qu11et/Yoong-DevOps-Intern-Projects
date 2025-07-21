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

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "security-group-default"
}

variable "security_group_rule_name" {
  description = "Name of the network security rule"
  type        = string
  default     = "security-rule-default"
}

variable "priority" {
  description = "Priority of the security rule"
  type        = number
}

variable "direction" {
  description = "Direction of the security rule (Inbound/Outbound)"
}

variable "access" {
  description = "Access type for the security rule (Allow/Deny)"
}

variable "protocol" {
  description = "Protocol for the security rule (e.g., TCP, UDP, *)"
}

variable "source_port_range" {
  description = "Source port range for the security rule"
}

variable "destination_port_range" {
  description = "Destination port range for the security rule"
}

variable "source_address_prefix" {
  description = "Source address prefix for the security rule"
}

variable "destination_address_prefix" {
  description = "Destination address prefix for the security rule"
} 