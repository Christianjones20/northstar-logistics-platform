output "resource_group_name" {
  description = "The name of the northstar resource group created."
  value       = azurerm_resource_group.northstar_rg.name
}

output "resource_group_id" {
  description = "The ID of the northstar resource group created."
  value       = azurerm_resource_group.northstar_rg.id
}

output "resource_group_location" {
  description = "The location of the northstar resource group created."
  value       = azurerm_resource_group.northstar_rg.location
}