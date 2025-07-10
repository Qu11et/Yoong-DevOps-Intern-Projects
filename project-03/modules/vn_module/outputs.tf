output "vn_id" {
  value       = azurerm_virtual_network.yoong-vn.id
  description = "The Id of the VN"
}

output "virtual_network_name" {
  value = azurerm_virtual_network.yoong-vn.name
  description = "The name of the created virtual network"
}