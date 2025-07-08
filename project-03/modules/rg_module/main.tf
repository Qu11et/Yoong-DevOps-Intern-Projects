resource "azurerm_resource_group" "yoong-rg" {
  name     = "yoong-resources"
  location = "Southeast Asia"
  tags = {
    environment = "dev"
  }
}