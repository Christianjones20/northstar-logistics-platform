# --------------------------------------------------
# LOG ANALYTICS WORKSPACE
# --------------------------------------------------

resource "azurerm_log_analytics_workspace" "northstar" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = var.log_analytics_sku
  retention_in_days = var.log_analytics_retention_days

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.environment
    managed_by  = "terraform"
  }
}