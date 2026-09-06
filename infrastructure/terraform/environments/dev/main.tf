resource "azurerm_resource_group" "northstar_rg" {
  name     = var.RESOURCE_GROUP_NAME
  location = var.LOCATION

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.ENVIRONMENT
    managed_by  = "terraform"


  }
}