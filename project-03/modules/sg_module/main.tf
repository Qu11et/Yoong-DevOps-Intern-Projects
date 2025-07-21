resource "azurerm_network_security_group" "yoong-sg" {
  name                = var.security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "yoong-sg-rule-1" {
  name                        = var.security_group_rule_name
  priority                    = var.priority
  direction                   = var.direction
  access                      = var.access
  protocol                    = var.protocol
  source_port_range           = var.source_port_range
  destination_port_range      = var.destination_port_range
  source_address_prefix       = var.source_address_prefix
  destination_address_prefix  = var.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.yoong-sg.name
}

resource "azurerm_subnet_network_security_group_association" "yoong-sga" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.yoong-sg.id
}