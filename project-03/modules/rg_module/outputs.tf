output "vn_id" {
  value       = azurerm_resource_group.yoong-rg.id
  description = "The Id of the RG"
}

output "resource_group_name" {
  value = azurerm_resource_group.yoong-rg.name
  description = "The name of the created resource group"
}

output "resource_group_location" {
  value = azurerm_resource_group.yoong-rg.location
  description = "Azure region where resources will be created"
}
