# --------------------------------------------------
# KEY VAULT
# --------------------------------------------------

output "key_vault_id" {
  description = "The resource ID of the NorthStar Key Vault."
  value       = azurerm_key_vault.northstar.id
}

output "key_vault_name" {
  description = "The name of the NorthStar Key Vault."
  value       = azurerm_key_vault.northstar.name
}

output "key_vault_url" {
  description = "The URI of the NorthStar Key Vault."
  value       = azurerm_key_vault.northstar.vault_uri
}


# --------------------------------------------------
# BACKEND MANAGED IDENTITY
# --------------------------------------------------

output "backend_identity_id" {
  description = "The resource ID of the NorthStar backend managed identity."
  value       = azurerm_user_assigned_identity.backend.id
}

output "backend_identity_client_id" {
  description = "The client ID of the NorthStar backend managed identity."
  value       = azurerm_user_assigned_identity.backend.client_id
}

output "backend_identity_principal_id" {
  description = "The principal ID of the NorthStar backend managed identity."
  value       = azurerm_user_assigned_identity.backend.principal_id
}