# --------------------------------------------------
# RESOURCE GROUP
# --------------------------------------------------

output "resource_group_name" {
  description = "The name of the NorthStar resource group."
  value       = azurerm_resource_group.northstar_rg.name
}

output "resource_group_id" {
  description = "The ID of the NorthStar resource group."
  value       = azurerm_resource_group.northstar_rg.id
}

output "resource_group_location" {
  description = "The location of the NorthStar resource group."
  value       = azurerm_resource_group.northstar_rg.location
}


# --------------------------------------------------
# NETWORKING
# --------------------------------------------------

output "vnet_name" {
  description = "The name of the NorthStar virtual network."
  value       = module.networking.vnet_name
}

output "vnet_id" {
  description = "The ID of the NorthStar virtual network."
  value       = module.networking.vnet_id
}

output "aks_subnet_id" {
  description = "The ID of the NorthStar AKS subnet."
  value       = module.networking.aks_subnet_id
}

output "data_subnet_id" {
  description = "The ID of the NorthStar data subnet."
  value       = module.networking.data_subnet_id
}

output "service_subnet_id" {
  description = "The ID of the NorthStar service subnet."
  value       = module.networking.service_subnet_id
}

output "aks_nsg_id" {
  description = "The ID of the NorthStar AKS network security group."
  value       = module.networking.aks_nsg_id
}

output "data_nsg_id" {
  description = "The ID of the NorthStar data network security group."
  value       = module.networking.data_nsg_id
}

output "service_nsg_id" {
  description = "The ID of the NorthStar service network security group."
  value       = module.networking.service_nsg_id
}


# --------------------------------------------------
# CONTAINER PLATFORM
# --------------------------------------------------

output "acr_name" {
  description = "The name of the NorthStar Azure Container Registry."
  value       = module.container_platform.acr_name
}

output "acr_id" {
  description = "The ID of the NorthStar Azure Container Registry."
  value       = module.container_platform.acr_id
}

output "acr_login_server" {
  description = "The login server for the NorthStar Azure Container Registry."
  value       = module.container_platform.acr_login_server
}

output "aks_name" {
  description = "The name of the NorthStar AKS cluster."
  value       = module.container_platform.aks_name
}

output "aks_id" {
  description = "The ID of the NorthStar AKS cluster."
  value       = module.container_platform.aks_id
}

output "aks_node_resource_group" {
  description = "The node resource group used by the NorthStar AKS cluster."
  value       = module.container_platform.aks_node_resource_group
}

output "aks_kubelet_identity_object_id" {
  description = "The object ID of the NorthStar AKS kubelet identity."
  value       = module.container_platform.aks_kubelet_identity_object_id
}


# --------------------------------------------------
# DATABASE
# --------------------------------------------------

output "postgres_server_name" {
  description = "The name of the NorthStar PostgreSQL Flexible Server."
  value       = module.database.postgres_server_name
}

output "postgres_fqdn" {
  description = "The fully qualified domain name of the NorthStar PostgreSQL Flexible Server."
  value       = module.database.postgres_fqdn
}

output "postgres_database_name" {
  description = "The name of the NorthStar PostgreSQL database."
  value       = module.database.postgres_database_name
}


# --------------------------------------------------
# SECURITY
# --------------------------------------------------

output "key_vault_name" {
  description = "The name of the NorthStar Key Vault."
  value       = module.security.key_vault_name
}

output "key_vault_url" {
  description = "The URI of the NorthStar Key Vault."
  value       = module.security.key_vault_url
}

output "backend_identity_client_id" {
  description = "The client ID of the NorthStar backend managed identity."
  value       = module.security.backend_identity_client_id
}

output "backend_identity_principal_id" {
  description = "The principal ID of the NorthStar backend managed identity."
  value       = module.security.backend_identity_principal_id
}


# --------------------------------------------------
# MONITORING
# --------------------------------------------------

output "log_analytics_workspace_name" {
  description = "The name of the NorthStar Log Analytics workspace."
  value       = module.monitoring.log_analytics_workspace_name
}

output "log_analytics_workspace_id" {
  description = "The ID of the NorthStar Log Analytics workspace."
  value       = module.monitoring.log_analytics_workspace_id
}

output "log_analytics_workspace_workspace_id" {
  description = "The workspace/customer ID of the NorthStar Log Analytics workspace."
  value       = module.monitoring.log_analytics_workspace_workspace_id
}