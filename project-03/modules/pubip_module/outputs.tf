output "public_ip_name" {
  value = azurerm_public_ip.yoong-ip.name
  description = "The name of the created public IP"
}

output "public_ip_id" {
  value = azurerm_public_ip.yoong-ip.id
  description = "The ID of the created public IP"
}