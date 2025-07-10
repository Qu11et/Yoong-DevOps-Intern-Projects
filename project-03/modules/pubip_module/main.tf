resource "azurerm_public_ip" "yoong-ip" {
  name                = "yoong-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"  # Use Static allocation for Standard SKU
  sku                 = "Standard"  # Use Standard SKU for better performance and features

  tags = {
    environment = "dev"
  }
}