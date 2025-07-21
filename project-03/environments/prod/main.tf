module "rg_module" {
  source              = "../../modules/rg_module"
  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = "prod"
}

module "vn_module" {
  source               = "../../modules/vn_module"
  resource_group_name  = var.resource_group_name
  location             = var.location
  address_space        = ["10.123.0.0/16"]
  virtual_network_name = var.virtual_network_name

  depends_on = [
    module.rg_module
  ]
}

module "subnet_module" {
  source               = "../../modules/subnet_module"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_name          = "yoong-subnet-1"
  address_prefixes     = ["10.123.1.0/24"]
  //security_group_id   = module.sg_module.security_group_id

  depends_on = [
    module.vn_module
  ]
}

module "sg_module" {
  source                     = "../../modules/sg_module"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  subnet_id                  = module.subnet_module.subnet_id
  security_group_name        = "yoong-security-group"
  security_group_rule_name   = "yoong-rule-1"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "*"
  destination_address_prefix = "*"

  depends_on = [
    module.subnet_module
  ]
}

module "pubip_module" {
  source              = "../../modules/pubip_module"
  resource_group_name = var.resource_group_name
  location            = var.location
  public_ip_name      = "yoong-public-ip"

  depends_on = [
    module.sg_module
  ]
}

module "nic_module" {
  source                 = "../../modules/nic_module"
  network_interface_name = "yoong-nic"
  resource_group_name    = var.resource_group_name
  location               = var.location
  subnet_id              = module.subnet_module.subnet_id
  public_ip_id           = module.pubip_module.public_ip_id

  depends_on = [
    module.pubip_module
  ]
}

module "vm_module" {
  source               = "../../modules/vm_module"
  resource_group_name  = var.resource_group_name
  location             = var.location
  network_interface_id = module.nic_module.network_interface_id
  ssh_public_key       = var.ssh_public_key
  vm_name              = "yoong-vm"
  vm_size              = "Standard_B2ats_v2"
  admin_username       = "adminuser"
  storage_account_type = "Standard_LRS"
  publisher            = "Canonical"
  offer                = "0001-com-ubuntu-server-jammy"
  sku                  = "22_04-lts"

  depends_on = [
    module.nic_module
  ]
}