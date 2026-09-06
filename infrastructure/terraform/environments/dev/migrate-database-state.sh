#!/usr/bin/env bash

set -e

echo "Backing up Terraform state..."
terraform state pull > terraform-state-backup-database.json

echo "Moving PostgreSQL Private DNS Zone..."
terraform state mv \
azurerm_private_dns_zone.postgres \
module.database.azurerm_private_dns_zone.postgres

echo "Moving PostgreSQL Private DNS VNet Link..."
terraform state mv \
azurerm_private_dns_zone_virtual_network_link.postgres \
module.database.azurerm_private_dns_zone_virtual_network_link.postgres

echo "Moving PostgreSQL Flexible Server..."
terraform state mv \
azurerm_postgresql_flexible_server.northstar_postgres \
module.database.azurerm_postgresql_flexible_server.northstar

echo "Moving PostgreSQL Database..."
terraform state mv \
azurerm_postgresql_flexible_server_database.northstar_postgres_db \
module.database.azurerm_postgresql_flexible_server_database.northstar

echo
echo "Database state migration complete."
echo

echo "Current database module resources:"
terraform state list | grep "module.database"

echo
echo "Running Terraform plan..."
terraform plan
