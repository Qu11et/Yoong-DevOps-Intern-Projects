output "vm_id" {
  value       = azurerm_linux_virtual_machine.yoong-vm.id
  description = "The ID of the created virtual machine"
}

output "vm_name" {
  value       = azurerm_linux_virtual_machine.yoong-vm.name
  description = "The name of the created virtual machine"
}