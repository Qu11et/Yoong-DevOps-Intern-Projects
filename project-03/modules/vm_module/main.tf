resource "azurerm_linux_virtual_machine" "yoong-vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username

  allow_extension_operations = false

  network_interface_ids = [
    var.network_interface_id,
  ]

  admin_ssh_key {
    username = "adminuser"
    //public_key = file("./.ssh/azurekey.pub")
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }
}