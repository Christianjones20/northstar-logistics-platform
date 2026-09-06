#!/usr/bin/env bash

set -e

echo "========================================"
echo "NorthStar Security Module State Migration"
echo "========================================"

echo
echo "Creating Terraform state backup..."

terraform state pull > terraform-state-backup-security.json

echo "State backup created:"
echo "terraform-state-backup-security.json"


echo
echo "Moving Key Vault..."

terraform state mv \
  azurerm_key_vault.northstar_kv \
  module.security.azurerm_key_vault.northstar


echo
echo "Moving backend managed identity..."

terraform state mv \
  azurerm_user_assigned_identity.northstar_backend_identity \
  module.security.azurerm_user_assigned_identity.backend


echo
echo "Moving Terraform operator Key Vault role assignment..."

terraform state mv \
  azurerm_role_assignment.current_user_key_vault_secrets \
  module.security.azurerm_role_assignment.current_user_key_vault_secrets


echo
echo "Moving backend Key Vault role assignment..."

terraform state mv \
  azurerm_role_assignment.backend_identity_key_vault_secrets \
  module.security.azurerm_role_assignment.backend_key_vault_secrets


echo
echo "Moving backend federated identity credential..."

terraform state mv \
  azurerm_federated_identity_credential.northstar_backend_federated_identity \
  module.security.azurerm_federated_identity_credential.backend


echo
echo "========================================"
echo "Security state migration complete."
echo "========================================"

echo
echo "Security resources now in Terraform state:"

terraform state list | grep "module.security"

echo
echo "Running Terraform plan..."

terraform plan
