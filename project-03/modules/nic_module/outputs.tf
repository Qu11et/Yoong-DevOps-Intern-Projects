output "network_interface_id" {
  value       = azurerm_network_interface.yoong-nic.id
  description = "The ID of the created network interface"
}

output "network_interface_name" {
  value       = azurerm_network_interface.yoong-nic.name
  description = "The name of the created network interface"
}