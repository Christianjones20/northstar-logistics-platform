# --------------------------------------------------
# VIRTUAL NETWORK
# --------------------------------------------------

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


# --------------------------------------------------
# AKS SUBNET
# --------------------------------------------------

resource "azurerm_subnet" "northstar_aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.northstar_vnet.name
  address_prefixes     = var.aks_subnet_prefix
}


# --------------------------------------------------
# DATA SUBNET
# --------------------------------------------------

resource "azurerm_subnet" "northstar_data_subnet" {
  name                 = "data-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.northstar_vnet.name
  address_prefixes     = var.data_subnet_prefix

  service_endpoint {
    service = "Microsoft.Storage"
  }

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


# --------------------------------------------------
# SERVICE SUBNET
# --------------------------------------------------

resource "azurerm_subnet" "northstar_service_subnet" {
  name                 = "service-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.northstar_vnet.name
  address_prefixes     = var.service_subnet_prefix
}


# --------------------------------------------------
# AKS NETWORK SECURITY GROUP
# --------------------------------------------------

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


# --------------------------------------------------
# AKS INGRESS RULES
# --------------------------------------------------

# Allow public HTTP/HTTPS traffic to the ingress controller
resource "azurerm_network_security_rule" "allow_nginx_ingress_web" {
  name                        = "Allow-Nginx-Ingress-Web"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]

  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.northstar_aks_nsg.name
}

# Allow Azure Load Balancer health probes to reach ingress-nginx NodePorts
resource "azurerm_network_security_rule" "allow_nginx_health_probes" {
  name                        = "Allow-Nginx-Health-Probes"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_port_range           = "*"
  destination_port_ranges     = ["31061", "31689"]

  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.northstar_aks_nsg.name
}


# --------------------------------------------------
# DATA NETWORK SECURITY GROUP
# --------------------------------------------------

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


# --------------------------------------------------
# SERVICE NETWORK SECURITY GROUP
# --------------------------------------------------

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


# --------------------------------------------------
# NSG ASSOCIATIONS
# --------------------------------------------------

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