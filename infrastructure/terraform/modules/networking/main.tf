# Virtual Network
resource "azurerm_virtual_network" "northstar_vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.environment
    managed_by  = "terraform"
  }
}

# AKS Subnet
resource "azurerm_subnet" "northstar_aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.northstar_vnet.name
  address_prefixes     = var.aks_subnet_prefix
}

# Data Subnet
resource "azurerm_subnet" "northstar_data_subnet" {
  name                 = "data-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.northstar_vnet.name
  address_prefixes     = var.data_subnet_prefix

  delegation {
    name = "postgresql_delegation"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"
      ]
    }
  }
}

# Service Subnet
resource "azurerm_subnet" "northstar_service_subnet" {
  name                 = "service-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.northstar_vnet.name
  address_prefixes     = var.service_subnet_prefix
}

# AKS NSG
resource "azurerm_network_security_group" "northstar_aks_nsg" {
  name                = var.aks_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.environment
    managed_by  = "terraform"
  }
}

# Data NSG
resource "azurerm_network_security_group" "northstar_data_nsg" {
  name                = var.data_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.environment
    managed_by  = "terraform"
  }
}

# Service NSG
resource "azurerm_network_security_group" "northstar_service_nsg" {
  name                = var.service_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    project     = "northstar-logistics-platform"
    environment = var.environment
    managed_by  = "terraform"
  }
}

# NSG Associations
resource "azurerm_subnet_network_security_group_association" "northstar_aks_nsg_association" {
  subnet_id                 = azurerm_subnet.northstar_aks_subnet.id
  network_security_group_id = azurerm_network_security_group.northstar_aks_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "northstar_data_nsg_association" {
  subnet_id                 = azurerm_subnet.northstar_data_subnet.id
  network_security_group_id = azurerm_network_security_group.northstar_data_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "northstar_service_nsg_association" {
  subnet_id                 = azurerm_subnet.northstar_service_subnet.id
  network_security_group_id = azurerm_network_security_group.northstar_service_nsg.id
}