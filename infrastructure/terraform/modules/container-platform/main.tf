#Azure Container Registry

resource "azurerm_container_registry" "northstar" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = false

  tags = {
    project     = "northstar-logistics"
    environment = var.environment
    managed_by  = "terraform"
  }
}


# AKS Managed Identity

resource "azurerm_user_assigned_identity" "aks" {
  name                = var.aks_identity_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    project     = "northstar-logistics"
    environment = var.environment
    managed_by  = "terraform"
  }
}


# AKS Network Contributor Role

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = var.aks_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
  principal_type       = "ServicePrincipal"
}

# AKS Cluster

resource "azurerm_kubernetes_cluster" "northstar" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_dns_prefix

  sku_tier = "Free"

  node_provisioning_profile {
    mode = "Manual"
  }

  oidc_issuer_enabled        = true
  workload_identity_enabled = true

  default_node_pool {
    name           = "system"
    node_count     = var.aks_node_count
    vm_size        = var.aks_vm_size
    vnet_subnet_id = var.aks_subnet_id
  }

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.aks.id
    ]
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"

    pod_cidr       = var.aks_pod_cidr
    service_cidr   = var.aks_service_cidr
    dns_service_ip = var.aks_dns_service_ip

    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  role_based_access_control_enabled = true

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  oms_agent {
    log_analytics_workspace_id      = var.log_analytics_workspace_id
    msi_auth_for_monitoring_enabled = true
  }

  tags = {
    project     = "northstar-logistics"
    environment = var.environment
    managed_by  = "terraform"
  }

  depends_on = [
    azurerm_role_assignment.aks_network_contributor
  ]
}


# AKS Pull Access to ACR

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.northstar.id
  role_definition_name = "AcrPull"

  principal_id = azurerm_kubernetes_cluster.northstar.kubelet_identity[0].object_id

  principal_type = "ServicePrincipal"
}