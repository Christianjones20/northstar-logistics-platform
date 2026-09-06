output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.northstar.name
}

output "acr_id" {
  description = "ID of the Azure Container Registry"
  value       = azurerm_container_registry.northstar.id
}

output "acr_login_server" {
  description = "Login server of the Azure Container Registry"
  value       = azurerm_container_registry.northstar.login_server
}

output "aks_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.northstar.name
}

output "aks_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.northstar.id
}

output "aks_node_resource_group" {
  description = "AKS-managed node resource group"
  value       = azurerm_kubernetes_cluster.northstar.node_resource_group
}

output "aks_kubelet_identity_object_id" {
  description = "Object ID of the AKS kubelet identity"
  value       = azurerm_kubernetes_cluster.northstar.kubelet_identity[0].object_id
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for AKS workload identity"
  value       = azurerm_kubernetes_cluster.northstar.oidc_issuer_url
}