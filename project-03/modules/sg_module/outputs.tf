output "security_group_id" {
  value       = azurerm_network_security_group.yoong-sg.id
  description = "The Id of the security group"
}

output "security_group_name" {
  value       = azurerm_network_security_group.yoong-sg.name
  description = "The name of the created security group"
}

