resource "azurerm_virtual_network" "yoong-vn" {
  name                = "yoong-network"
  address_space       = ["10.123.0.0/16"]
  resource_group_name = var.resource_group_name
  location            = var.location
  
  tags = {
    environment = "dev"
  }
}