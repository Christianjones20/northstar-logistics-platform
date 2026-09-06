# --------------------------------------------------
# RESOURCE GROUP
# --------------------------------------------------

output "resource_group_name" {
  description = "The name of the NorthStar production resource group."
  value       = azurerm_resource_group.northstar.name
}


# --------------------------------------------------
# NETWORKING
# --------------------------------------------------

output "vnet_id" {
  description = "The ID of the NorthStar production virtual network."
  value       = module.networking.vnet_id
}

output "aks_subnet_id" {
  description = "The ID of the NorthStar production AKS subnet."
  value       = module.networking.aks_subnet_id
}


# --------------------------------------------------
# CONTAINER PLATFORM
# --------------------------------------------------

output "acr_name" {
  description = "The name of the NorthStar production Azure Container Registry."
  value       = module.container_platform.acr_name
}

output "acr_login_server" {
  description = "The login server for the NorthStar production Azure Container Registry."
  value       = module.container_platform.acr_login_server
}

output "aks_name" {
  description = "The name of the NorthStar production AKS cluster."
  value       = module.container_platform.aks_name
}


# --------------------------------------------------
# DATABASE
# --------------------------------------------------

output "postgres_server_name" {
  description = "The name of the NorthStar production PostgreSQL Flexible Server."
  value       = module.database.postgres_server_name
}

output "postgres_fqdn" {
  description = "The fully qualified domain name of the NorthStar production PostgreSQL Flexible Server."
  value       = module.database.postgres_fqdn
}

output "postgres_database_name" {
  description = "The name of the NorthStar production PostgreSQL database."
  value       = module.database.postgres_database_name
}


# --------------------------------------------------
# SECURITY
# --------------------------------------------------

output "key_vault_name" {
  description = "The name of the NorthStar production Key Vault."
  value       = module.security.key_vault_name
}

output "backend_identity_client_id" {
  description = "The client ID of the NorthStar production backend managed identity."
  value       = module.security.backend_identity_client_id
}


# --------------------------------------------------
# MONITORING
# --------------------------------------------------

output "log_analytics_workspace_name" {
  description = "The name of the NorthStar production Log Analytics workspace."
  value       = module.monitoring.log_analytics_workspace_name
}

output "log_analytics_workspace_id" {
  description = "The resource ID of the NorthStar production Log Analytics workspace."
  value       = module.monitoring.log_analytics_workspace_id
}