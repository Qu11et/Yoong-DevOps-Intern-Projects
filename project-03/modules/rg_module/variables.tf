variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-module-default"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "Southeast Asia"
}

variable "environment" {
  description = "Environment for the resource group (e.g., dev, prod)"
  type        = string
}