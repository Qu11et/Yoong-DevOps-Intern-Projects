output "subnet_id" {
  value       = azurerm_subnet.yoong-subnet-1.id
  description = "The Id of the subnet 1"
}

output "subnet_name" {
  value       = azurerm_subnet.yoong-subnet-1.name
  description = "The name of the created subnet 1"
}