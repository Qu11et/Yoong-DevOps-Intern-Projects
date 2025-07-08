resource "azurerm_network_security_group" "yoong-sg" {
  name                = "yoong-security-group"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "yoong-sg-rule-1" {
  name                        = "yoong-dev-rule-1"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "115.79.142.112/32"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.yoong-sg.name
}

resource "azurerm_subnet_network_security_group_association" "yoong-sga" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.yoong-sg.id
}