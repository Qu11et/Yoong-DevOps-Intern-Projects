resource "azurerm_virtual_network" "yoong-vn" {
  name                = var.virtual_network_name
  address_space       = var.address_space
  resource_group_name = var.resource_group_name
  location            = var.location
}