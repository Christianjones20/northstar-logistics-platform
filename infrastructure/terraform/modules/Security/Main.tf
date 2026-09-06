# --------------------------------------------------
# KEY VAULT
# --------------------------------------------------

resource "azurerm_key_vault" "northstar" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id

  sku_name = "standard"

  rbac_authorization_enabled = true

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  public_network_access_enabled = true

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.environment
    managed_by  = "terraform"
  }
}


# --------------------------------------------------
# BACKEND MANAGED IDENTITY
# --------------------------------------------------

resource "azurerm_user_assigned_identity" "backend" {
  name                = var.backend_identity_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.environment
    managed_by  = "terraform"
  }
}


# --------------------------------------------------
# KEY VAULT RBAC
# --------------------------------------------------

resource "azurerm_role_assignment" "current_user_key_vault_secrets" {
  scope                = azurerm_key_vault.northstar.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.terraform_operator_object_id
}

resource "azurerm_role_assignment" "backend_key_vault_secrets" {
  scope                = azurerm_key_vault.northstar.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.backend.principal_id
}


# --------------------------------------------------
# AKS WORKLOAD IDENTITY FEDERATION
# --------------------------------------------------

resource "azurerm_federated_identity_credential" "backend" {
  name = "northstar-backend-federated-identity"

  user_assigned_identity_id = azurerm_user_assigned_identity.backend.id

  issuer = var.aks_oidc_issuer_url

  subject = "system:serviceaccount:${var.backend_namespace}:${var.backend_service_account_name}"

  audience = [
    "api://AzureADTokenExchange"
  ]
}