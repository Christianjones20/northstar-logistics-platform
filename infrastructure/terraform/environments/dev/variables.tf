# --------------------------------------------------
# GENERAL
# --------------------------------------------------

variable "RESOURCE_GROUP_NAME" {
  description = "Name of the NorthStar resource group."
  type        = string
  default     = "rg-northstar-dev"
}

variable "LOCATION" {
  description = "Azure region for the NorthStar development environment."
  type        = string
  default     = "Central US"
}

variable "ENVIRONMENT" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}


# --------------------------------------------------
# NETWORKING
# --------------------------------------------------

variable "VNET_NAME" {
  description = "Name of the NorthStar virtual network."
  type        = string
  default     = "vnet-northstar-dev"
}

variable "VNET_ADDRESS_SPACE" {
  description = "Address space for the NorthStar virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "AKS_SUBNET_PREFIX" {
  description = "Address prefix for the AKS subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "DATA_SUBNET_PREFIX" {
  description = "Address prefix for the data subnet."
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "SERVICE_SUBNET_PREFIX" {
  description = "Address prefix for the service subnet."
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

variable "AKS_NSG_NAME" {
  description = "Name of the AKS network security group."
  type        = string
  default     = "nsg-northstar-aks-dev"
}

variable "DATA_NSG_NAME" {
  description = "Name of the data network security group."
  type        = string
  default     = "nsg-northstar-data-dev"
}

variable "SERVICE_NSG_NAME" {
  description = "Name of the service network security group."
  type        = string
  default     = "nsg-northstar-service-dev"
}


# --------------------------------------------------
# AZURE CONTAINER REGISTRY
# --------------------------------------------------

variable "ACR_NAME" {
  description = "Name of the NorthStar Azure Container Registry."
  type        = string
  default     = "Northstarlogisticsdevacr"
}

variable "ACR_SKU" {
  description = "SKU for the NorthStar Azure Container Registry."
  type        = string
  default     = "Basic"
}


# --------------------------------------------------
# AKS
# --------------------------------------------------

variable "AKS_CLUSTER_NAME" {
  description = "Name of the NorthStar AKS cluster."
  type        = string
  default     = "aks-northstar-dev"
}

variable "AKS_DNS_PREFIX" {
  description = "DNS prefix for the NorthStar AKS cluster."
  type        = string
  default     = "northstar-dev"
}

variable "AKS_IDENTITY_NAME" {
  description = "Name of the managed identity used by the AKS cluster."
  type        = string
  default     = "id-aks-northstar-dev"
}

variable "AKS_NODE_COUNT" {
  description = "Number of nodes in the AKS system node pool."
  type        = number
  default     = 1
}

variable "AKS_NODE_VM_SIZE" {
  description = "Virtual machine size used by AKS nodes."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "AKS_POD_CIDR" {
  description = "CIDR range used for AKS pods."
  type        = string
  default     = "10.244.0.0/16"
}

variable "AKS_SERVICE_CIDR" {
  description = "CIDR range used for Kubernetes services."
  type        = string
  default     = "10.20.0.0/16"
}

variable "AKS_DNS_SERVICE_IP" {
  description = "DNS service IP used by the AKS cluster."
  type        = string
  default     = "10.20.0.10"
}


# --------------------------------------------------
# POSTGRESQL
# --------------------------------------------------

variable "postgres_server_name" {
  description = "Name of the NorthStar PostgreSQL Flexible Server."
  type        = string
  default     = "northstar-dev-postgres-server"
}

variable "postgres_database_name" {
  description = "Name of the NorthStar PostgreSQL database."
  type        = string
  default     = "northstar_dev_db"
}

variable "postgres_admin_username" {
  description = "Administrator username for the PostgreSQL Flexible Server."
  type        = string
  default     = "northstar_admin"
}

variable "postgres_admin_password" {
  description = "Administrator password for the PostgreSQL Flexible Server."
  type        = string
  sensitive   = true
}

variable "postgres_version" {
  description = "PostgreSQL server version."
  type        = string
  default     = "16"
}

variable "postgres_sku_name" {
  description = "SKU used by the development PostgreSQL Flexible Server."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgres_storage_mb" {
  description = "Storage allocated to the development PostgreSQL Flexible Server in MB."
  type        = number
  default     = 32768
}

variable "postgres_backup_retention_days" {
  description = "Backup retention period for the development PostgreSQL server."
  type        = number
  default     = 7
}

variable "postgres_private_dns_zone_name" {
  description = "Name of the PostgreSQL private DNS zone."
  type        = string
  default     = "northstar-dev.postgres.database.azure.com"
}

variable "postgres_private_dns_link_name" {
  description = "Name of the PostgreSQL private DNS virtual network link."
  type        = string
  default     = "northstar-dev-postgres-link"
}


# --------------------------------------------------
# SECURITY
# --------------------------------------------------

variable "key_vault_name" {
  description = "Name of the NorthStar Azure Key Vault."
  type        = string
  default     = "kv-northstar-dev0001"
}

variable "backend_identity_name" {
  description = "Name of the managed identity used by the NorthStar backend."
  type        = string
  default     = "id-backend-northstar-dev"
}

variable "backend_namespace" {
  description = "Kubernetes namespace used by the NorthStar backend."
  type        = string
  default     = "northstar-backend-dev"
}

variable "backend_service_account_name" {
  description = "Kubernetes service account used by the NorthStar backend."
  type        = string
  default     = "sa-backend-northstar-dev"
}


# --------------------------------------------------
# MONITORING
# --------------------------------------------------

variable "log_analytics_workspace_name" {
  description = "Name of the NorthStar Log Analytics workspace."
  type        = string
  default     = "law-northstar-dev"
}

variable "log_analytics_retention_in_days" {
  description = "Retention period for the NorthStar Log Analytics workspace in days."
  type        = number
  default     = 30
}

variable "log_analytics_sku" {
  description = "SKU used by the NorthStar Log Analytics workspace."
  type        = string
  default     = "PerGB2018"
}