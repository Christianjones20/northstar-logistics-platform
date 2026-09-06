#!/usr/bin/env bash

set -e

echo "Backing up Terraform state..."
terraform state pull > terraform-state-backup-container-platform.json

echo "Moving ACR..."
terraform state mv \
azurerm_container_registry.northstar_acr \
module.container_platform.azurerm_container_registry.northstar

echo "Moving AKS managed identity..."
terraform state mv \
azurerm_user_assigned_identity.northstar_identity \
module.container_platform.azurerm_user_assigned_identity.aks

echo "Moving AKS Network Contributor role assignment..."
terraform state mv \
azurerm_role_assignment.aks_network_contributor \
module.container_platform.azurerm_role_assignment.aks_network_contributor

echo "Moving AKS cluster..."
terraform state mv \
azurerm_kubernetes_cluster.northstar_aks \
module.container_platform.azurerm_kubernetes_cluster.northstar

echo "Moving ACR Pull role assignment..."
terraform state mv \
azurerm_role_assignment.acr_pull \
module.container_platform.azurerm_role_assignment.aks_acr_pull

echo
echo "State migration complete."
echo

echo "Current container-platform state:"
terraform state list | grep "module.container_platform"

echo
echo "Running terraform plan..."
terraform plan