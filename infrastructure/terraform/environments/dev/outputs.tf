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

output "vnet_name" {
  description = "The name of the northstar virtual network created."
  value       = module.networking.vnet_name
}

output "vnet_id" {
  description = "The ID of the northstar virtual network created."
  value       = module.networking.vnet_id
}

output "aks_subnet_id" {
  description = "The ID of the northstar AKS subnet created."
  value       = module.networking.aks_subnet_id
}

output "data_subnet_id" {
  description = "The ID of the northstar data subnet created."
  value       = module.networking.data_subnet_id
}

output "service_subnet_id" {
  description = "The ID of the northstar service subnet created."
  value       = module.networking.service_subnet_id
}

output "aks_nsg_id" {
  description = "The ID of the northstar AKS NSG created."
  value       = module.networking.aks_nsg_id
}

output "data_nsg_id" {
  description = "The ID of the northstar data NSG created."
  value       = module.networking.data_nsg_id
}

output "service_nsg_id" {
  description = "The ID of the northstar service NSG created."
  value       = module.networking.service_nsg_id
}

output "acr_name" {
  description = "The name of the northstar Azure Container Registry created."
  value       = azurerm_container_registry.northstar_acr.name
}

output "acr_id" {
  description = "The ID of the northstar Azure Container Registry created."
  value       = azurerm_container_registry.northstar_acr.id
}

output "acr_login_server" {
  description = "The login server of the northstar Azure Container Registry created."
  value       = azurerm_container_registry.northstar_acr.login_server
}

output "aks_name" {
  description = "The name of the northstar AKS cluster created."
  value       = azurerm_kubernetes_cluster.northstar_aks.name
}

output "aks_id" {
  description = "The ID of the northstar AKS cluster created."
  value       = azurerm_kubernetes_cluster.northstar_aks.id
}

output "aks_node_resource_group" {
  description = "The name of the node resource group of the northstar AKS cluster created."
  value       = azurerm_kubernetes_cluster.northstar_aks.node_resource_group
}

output "aks_kubelet_identity_object_id" {
  description = "The object ID of the kubelet identity of the northstar AKS cluster created."
  value       = azurerm_kubernetes_cluster.northstar_aks.kubelet_identity[0].object_id
}

output "postgres_server_name" {
  description = "The name of the northstar PostgreSQL server created."
  value       = azurerm_postgresql_flexible_server.northstar_postgres.name
}

output "postgres_fqdn" {
  description = "The fully qualified domain name of the northstar PostgreSQL server created."
  value       = azurerm_postgresql_flexible_server.northstar_postgres.fqdn
}

output "postgres_database_name" {
  description = "The name of the northstar PostgreSQL database created."
  value       = azurerm_postgresql_flexible_server_database.northstar_postgres_db.name
}

output "key_vault_name" {
  description = "The name of the northstar Key Vault created."
  value       = azurerm_key_vault.northstar_kv.name
}

output "key_vault_url" {
  description = "The URL of the northstar Key Vault created."
  value       = azurerm_key_vault.northstar_kv.vault_uri
}

output "backend_identity_client_id" {
  description = "The client ID of the northstar backend managed identity created."
  value       = azurerm_user_assigned_identity.northstar_backend_identity.client_id
}

output "backend_identity_principal_id" {
  description = "The principal ID of the northstar backend managed identity created."
  value       = azurerm_user_assigned_identity.northstar_backend_identity.principal_id
}

output "log_analytics_workspace_name" {
  description = "The name of the northstar Log Analytics workspace created."
  value       = azurerm_log_analytics_workspace.northstar_log_analytics.name
}

output "log_analytics_workspace_id" {
  description = "The ID of the northstar Log Analytics workspace created."
  value       = azurerm_log_analytics_workspace.northstar_log_analytics.id
}