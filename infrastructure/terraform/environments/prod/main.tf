data "azurerm_client_config" "current" {}


# --------------------------------------------------
# RESOURCE GROUP
# --------------------------------------------------

resource "azurerm_resource_group" "northstar" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.environment
    managed_by  = "terraform"
  }
}


# --------------------------------------------------
# NETWORKING
# --------------------------------------------------

module "networking" {
  source = "../../modules/networking"

  resource_group_name = azurerm_resource_group.northstar.name
  location            = azurerm_resource_group.northstar.location
  environment         = var.environment

  vnet_name          = var.vnet_name
  vnet_address_space = var.vnet_address_space

  aks_subnet_prefix     = var.aks_subnet_prefix
  data_subnet_prefix    = var.data_subnet_prefix
  service_subnet_prefix = var.service_subnet_prefix

  aks_nsg_name     = var.aks_nsg_name
  data_nsg_name    = var.data_nsg_name
  service_nsg_name = var.service_nsg_name
}


# --------------------------------------------------
# MONITORING
# --------------------------------------------------

module "monitoring" {
  source = "../../modules/monitoring"

  resource_group_name = azurerm_resource_group.northstar.name
  location            = azurerm_resource_group.northstar.location
  environment         = var.environment

  log_analytics_workspace_name = var.log_analytics_workspace_name
  log_analytics_retention_days = var.log_analytics_retention_days
  log_analytics_sku            = var.log_analytics_sku
}


# --------------------------------------------------
# CONTAINER PLATFORM
# --------------------------------------------------

module "container_platform" {
  source = "../../modules/container-platform"

  resource_group_name = azurerm_resource_group.northstar.name
  location            = azurerm_resource_group.northstar.location
  environment         = var.environment

  acr_name = var.acr_name
  acr_sku  = var.acr_sku

  aks_name          = var.aks_name
  aks_dns_prefix    = var.aks_dns_prefix
  aks_identity_name = var.aks_identity_name

  aks_node_count = var.aks_node_count
  aks_vm_size    = var.aks_vm_size

  aks_subnet_id = module.networking.aks_subnet_id

  aks_pod_cidr       = var.aks_pod_cidr
  aks_service_cidr   = var.aks_service_cidr
  aks_dns_service_ip = var.aks_dns_service_ip

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
}


# --------------------------------------------------
# DATABASE
# --------------------------------------------------

module "database" {
  source = "../../modules/database"

  resource_group_name = azurerm_resource_group.northstar.name
  location            = azurerm_resource_group.northstar.location
  environment         = var.environment

  vnet_id        = module.networking.vnet_id
  data_subnet_id = module.networking.data_subnet_id

  private_dns_zone_name = var.postgres_private_dns_zone_name
  private_dns_link_name = var.postgres_private_dns_link_name

  postgres_server_name   = var.postgres_server_name
  postgres_database_name = var.postgres_database_name

  postgres_admin_username = var.postgres_admin_username
  postgres_admin_password = var.postgres_admin_password

  postgres_version               = var.postgres_version
  postgres_sku_name              = var.postgres_sku_name
  postgres_storage_mb            = var.postgres_storage_mb
  postgres_backup_retention_days = var.postgres_backup_retention_days
}


# --------------------------------------------------
# SECURITY
# --------------------------------------------------

module "security" {
  source = "../../modules/Security"

  resource_group_name = azurerm_resource_group.northstar.name
  location            = azurerm_resource_group.northstar.location
  environment         = var.environment

  tenant_id = data.azurerm_client_config.current.tenant_id

  terraform_operator_object_id = data.azurerm_client_config.current.object_id

  key_vault_name        = var.key_vault_name
  backend_identity_name = var.backend_identity_name

  aks_oidc_issuer_url = module.container_platform.oidc_issuer_url

  backend_namespace            = var.backend_namespace
  backend_service_account_name = var.backend_service_account_name
}
