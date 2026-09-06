#!/usr/bin/env bash
set -e

terraform state pull > terraform-state-backup.json


terraform state mv \
azurerm_subnet.northstar_aks_subnet \
module.networking.azurerm_subnet.northstar_aks_subnet

terraform state mv \
azurerm_subnet.northstar_data_subnet \
module.networking.azurerm_subnet.northstar_data_subnet

terraform state mv \
azurerm_subnet.northstar_service_subnet \
module.networking.azurerm_subnet.northstar_service_subnet

terraform state mv \
azurerm_network_security_group.northstar_aks_nsg \
module.networking.azurerm_network_security_group.northstar_aks_nsg

terraform state mv \
azurerm_network_security_group.northstar_data_nsg \
module.networking.azurerm_network_security_group.northstar_data_nsg

terraform state mv \
azurerm_network_security_group.northstar_service_nsg \
module.networking.azurerm_network_security_group.northstar_service_nsg

terraform state mv \
azurerm_subnet_network_security_group_association.northstar_aks_nsg \
module.networking.azurerm_subnet_network_security_group_association.northstar_aks_nsg_association

terraform state mv \
azurerm_subnet_network_security_group_association.northstar_data_nsg \
module.networking.azurerm_subnet_network_security_group_association.northstar_data_nsg_association

terraform state mv \
azurerm_subnet_network_security_group_association.northstar_service_nsg \
module.networking.azurerm_subnet_network_security_group_association.northstar_service_nsg_association

terraform state list
terraform plan