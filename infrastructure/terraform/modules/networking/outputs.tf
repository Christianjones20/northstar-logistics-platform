output "vnet_id" {
  description = "ID of the NorthStar virtual network"
  value       = azurerm_virtual_network.northstar_vnet.id
}

output "vnet_name" {
  description = "Name of the NorthStar virtual network"
  value       = azurerm_virtual_network.northstar_vnet.name
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.northstar_aks_subnet.id
}

output "data_subnet_id" {
  description = "ID of the data subnet"
  value       = azurerm_subnet.northstar_data_subnet.id
}

output "service_subnet_id" {
  description = "ID of the service subnet"
  value       = azurerm_subnet.northstar_service_subnet.id
}

output "aks_nsg_id" {
  description = "ID of the AKS Network Security Group"
  value       = azurerm_network_security_group.northstar_aks_nsg.id
}

output "data_nsg_id" {
  description = "ID of the data Network Security Group"
  value       = azurerm_network_security_group.northstar_data_nsg.id
}

output "service_nsg_id" {
  description = "ID of the service Network Security Group"
  value       = azurerm_network_security_group.northstar_service_nsg.id
}