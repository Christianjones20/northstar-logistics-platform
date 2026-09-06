# --------------------------------------------------
# POSTGRESQL PRIVATE DNS ZONE
# --------------------------------------------------

resource "azurerm_private_dns_zone" "postgres" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name

  tags = {
    project     = "northstar-logistics"
    environment = var.environment
    managed_by  = "terraform"
  }
}


# --------------------------------------------------
# PRIVATE DNS VNET LINK
# --------------------------------------------------

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name = var.private_dns_link_name

  private_dns_zone_id = azurerm_private_dns_zone.postgres.id
  virtual_network_id  = var.vnet_id

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.environment
    managed_by  = "terraform"
  }
}


# --------------------------------------------------
# POSTGRESQL FLEXIBLE SERVER
# --------------------------------------------------

resource "azurerm_postgresql_flexible_server" "northstar" {
  name                = var.postgres_server_name
  resource_group_name = var.resource_group_name
  location            = var.location

  version = var.postgres_version

  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password

  delegated_subnet_id = var.data_subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.postgres.id

  public_network_access_enabled = false

  zone = "3"

  sku_name   = var.postgres_sku_name
  storage_mb = var.postgres_storage_mb

  backup_retention_days = var.postgres_backup_retention_days

  tags = {
    project     = "northstar-logistics"
    environment = var.environment
    managed_by  = "terraform"
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgres
  ]
}


# --------------------------------------------------
# NORTHSTAR DATABASE
# --------------------------------------------------

resource "azurerm_postgresql_flexible_server_database" "northstar" {
  name      = var.postgres_database_name
  server_id = azurerm_postgresql_flexible_server.northstar.id

  charset   = "UTF8"
  collation = "en_US.utf8"
}