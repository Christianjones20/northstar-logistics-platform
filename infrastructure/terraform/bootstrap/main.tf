terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}


# --------------------------------------------------
# TERRAFORM STATE RESOURCE GROUP
# --------------------------------------------------

resource "azurerm_resource_group" "tfstate" {
  name     = "rg-northstar-tfstate"
  location = "eastus"

  tags = {
    project    = "northstar-logistics-platform"
    purpose    = "terraform-state"
    managed_by = "terraform"
  }
}


# --------------------------------------------------
# TERRAFORM STATE STORAGE ACCOUNT
# --------------------------------------------------

resource "azurerm_storage_account" "tfstate" {
  name                     = "stnorthstartfstate001"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 7
    }
  }

  tags = {
    project    = "northstar-logistics-platform"
    purpose    = "terraform-state"
    managed_by = "terraform"
  }

  lifecycle {
    prevent_destroy = true
  }
}


# --------------------------------------------------
# TERRAFORM STATE CONTAINER
# --------------------------------------------------

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}


# --------------------------------------------------
# TERRAFORM STATE ACCESS
# --------------------------------------------------

resource "azurerm_role_assignment" "terraform_state_access" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}