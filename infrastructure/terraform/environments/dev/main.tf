data "azurerm_client_config" "current" {}

# ============================================================
# Resource Group
# ============================================================

resource "azurerm_resource_group" "northstar_rg" {
  name     = var.RESOURCE_GROUP_NAME
  location = var.LOCATION

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.ENVIRONMENT
    managed_by  = "terraform"
  }
}


# ============================================================
# Networking Module
# ============================================================

module "networking" {
  source = "../../modules/networking"

  resource_group_name = azurerm_resource_group.northstar_rg.name
  location            = azurerm_resource_group.northstar_rg.location
  environment         = var.ENVIRONMENT

  vnet_name          = var.VNET_NAME
  vnet_address_space = var.VNET_ADDRESS_SPACE

  aks_subnet_prefix     = var.AKS_SUBNET_PREFIX
  data_subnet_prefix    = var.DATA_SUBNET_PREFIX
  service_subnet_prefix = var.SERVICE_SUBNET_PREFIX

  aks_nsg_name     = var.AKS_NSG_NAME
  data_nsg_name    = var.DATA_NSG_NAME
  service_nsg_name = var.SERVICE_NSG_NAME
}


# ============================================================
# PostgreSQL Private DNS
# ============================================================

resource "azurerm_private_dns_zone" "postgres" {
  name                = "northstar-dev.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.northstar_rg.name

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.ENVIRONMENT
    managed_by  = "terraform"
  }
}


resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                = "northstar-dev-postgres-link"
  private_dns_zone_id = azurerm_private_dns_zone.postgres.id

  virtual_network_id = module.networking.vnet_id

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.ENVIRONMENT
    managed_by  = "terraform"
  }
}


# ============================================================
# Azure Container Registry
# ============================================================

resource "azurerm_container_registry" "northstar_acr" {
  name                = var.ACR_NAME
  resource_group_name = azurerm_resource_group.northstar_rg.name
  location            = azurerm_resource_group.northstar_rg.location

  sku           = var.ACR_SKU
  admin_enabled = false

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.ENVIRONMENT
    managed_by  = "terraform"
  }
}


# ============================================================
# AKS Managed Identity
# ============================================================

resource "azurerm_user_assigned_identity" "northstar_identity" {
  name                = var.AKS_IDENTITY_NAME
  resource_group_name = azurerm_resource_group.northstar_rg.name
  location            = azurerm_resource_group.northstar_rg.location

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.ENVIRONMENT
    managed_by  = "terraform"
  }
}


# ============================================================
# AKS Network Contributor
# ============================================================

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = module.networking.aks_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.northstar_identity.principal_id
}


# ============================================================
# Log Analytics Workspace
# ============================================================

resource "azurerm_log_analytics_workspace" "northstar_log_analytics" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.northstar_rg.location
  resource_group_name = azurerm_resource_group.northstar_rg.name

  sku               = "PerGB2018"
  retention_in_days = var.log_analytics_retention_in_days

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.ENVIRONMENT
    managed_by  = "terraform"
  }
}


# ============================================================
# AKS Cluster
# ============================================================

resource "azurerm_kubernetes_cluster" "northstar_aks" {
  name                = var.AKS_CLUSTER_NAME
  location            = azurerm_resource_group.northstar_rg.location
  resource_group_name = azurerm_resource_group.northstar_rg.name
  dns_prefix          = var.AKS_DNS_PREFIX

  sku_tier = "Free"

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  node_provisioning_profile {
    mode = "Manual"
  }

  oms_agent {
    log_analytics_workspace_id      = azurerm_log_analytics_workspace.northstar_log_analytics.id
    msi_auth_for_monitoring_enabled = true
  }

  default_node_pool {
    name           = "system"
    node_count     = var.AKS_NODE_COUNT
    vm_size        = var.AKS_NODE_VM_SIZE
    vnet_subnet_id = module.networking.aks_subnet_id
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.northstar_identity.id
    ]
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"

    pod_cidr       = var.AKS_POD_CIDR
    service_cidr   = var.AKS_SERVICE_CIDR
    dns_service_ip = var.AKS_DNS_SERVICE_IP

    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.ENVIRONMENT
    managed_by  = "terraform"
  }

  depends_on = [
    azurerm_role_assignment.aks_network_contributor
  ]
}


# ============================================================
# AKS Access to Azure Container Registry
# ============================================================

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.northstar_acr.id
  role_definition_name = "AcrPull"

  principal_id = (
    azurerm_kubernetes_cluster.northstar_aks.kubelet_identity[0].object_id
  )

  principal_type = "ServicePrincipal"
}


# ============================================================
# PostgreSQL Flexible Server
# ============================================================

resource "azurerm_postgresql_flexible_server" "northstar_postgres" {
  name                = var.postgres_server_name
  resource_group_name = azurerm_resource_group.northstar_rg.name
  location            = azurerm_resource_group.northstar_rg.location

  version = "15"

  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password

  delegated_subnet_id = module.networking.data_subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.postgres.id

  public_network_access_enabled = false

  zone = "3"

  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768

  backup_retention_days = 7

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.ENVIRONMENT
    managed_by  = "terraform"
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgres
  ]
}


# ============================================================
# PostgreSQL Database
# ============================================================

resource "azurerm_postgresql_flexible_server_database" "northstar_postgres_db" {
  name      = var.postgres_database_name
  server_id = azurerm_postgresql_flexible_server.northstar_postgres.id

  charset   = "UTF8"
  collation = "en_US.utf8"
}


# ============================================================
# Key Vault
# ============================================================

resource "azurerm_key_vault" "northstar_kv" {
  name                = var.key_vault_name
  resource_group_name = azurerm_resource_group.northstar_rg.name
  location            = azurerm_resource_group.northstar_rg.location

  tenant_id = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  rbac_authorization_enabled = true

  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  public_network_access_enabled = true

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.ENVIRONMENT
    managed_by  = "terraform"
  }
}


# ============================================================
# Current User Key Vault Access
# ============================================================

resource "azurerm_role_assignment" "current_user_key_vault_secrets" {
  scope                = azurerm_key_vault.northstar_kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}


# ============================================================
# Backend Workload Identity
# ============================================================

resource "azurerm_user_assigned_identity" "northstar_backend_identity" {
  name                = var.backend_identity_name
  resource_group_name = azurerm_resource_group.northstar_rg.name
  location            = azurerm_resource_group.northstar_rg.location

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.ENVIRONMENT
    managed_by  = "terraform"
  }
}


# ============================================================
# Backend Identity Key Vault Access
# ============================================================

resource "azurerm_role_assignment" "backend_identity_key_vault_secrets" {
  scope                = azurerm_key_vault.northstar_kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.northstar_backend_identity.principal_id
}


# ============================================================
# AKS Workload Identity Federation
# ============================================================

resource "azurerm_federated_identity_credential" "northstar_backend_federated_identity" {
  name = "northstar-backend-federated-identity"

  user_assigned_identity_id = azurerm_user_assigned_identity.northstar_backend_identity.id

  issuer = azurerm_kubernetes_cluster.northstar_aks.oidc_issuer_url

  subject = "system:serviceaccount:${var.backend_namespace}:${var.backend_service_account_name}"

  audience = [
    "api://AzureADTokenExchange"
  ]
}
