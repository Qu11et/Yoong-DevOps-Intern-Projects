terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "rg_module" {
  source              = "./modules/rg_module"
}

module "vn_module" {
  source              = "./modules/vn_module"
  resource_group_name = module.rg_module.resource_group_name
  location            = module.rg_module.resource_group_location
}

module "subnet_module" {
  source               = "./modules/subnet_module"
  resource_group_name  = module.rg_module.resource_group_name
  virtual_network_name = module.vn_module.virtual_network_name
}

module "sg_module" {
  source              = "./modules/sg_module"
  resource_group_name = module.rg_module.resource_group_name
  location            = module.rg_module.resource_group_location
  subnet_id           = module.subnet_module.subnet_id
}

module "pubip_module" {
  source              = "./modules/pubip_module"
  resource_group_name = module.rg_module.resource_group_name
  location            = module.rg_module.resource_group_location
}

module "nic_module" {
  source              = "./modules/nic_module"
  resource_group_name = module.rg_module.resource_group_name
  location            = module.rg_module.resource_group_location
  subnet_id           = module.subnet_module.subnet_id
  public_ip_id        = module.pubip_module.public_ip_id
}

module "vm_module" {
  source              = "./modules/vm_module"
  resource_group_name = module.rg_module.resource_group_name
  location            = module.rg_module.resource_group_location
  network_interface_id = module.nic_module.network_interface_id
}