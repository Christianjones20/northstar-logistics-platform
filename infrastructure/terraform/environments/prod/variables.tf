# --------------------------------------------------
# GENERAL
# --------------------------------------------------

variable "resource_group_name" {
  description = "Name of the NorthStar production resource group."
  type        = string
  default     = "rg-northstar-prod"
}

variable "location" {
  description = "Azure region for the NorthStar production environment."
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "prod"
}


# --------------------------------------------------
# NETWORKING
# --------------------------------------------------

variable "vnet_name" {
  description = "Name of the NorthStar production virtual network."
  type        = string
  default     = "vnet-northstar-prod"
}

variable "vnet_address_space" {
  description = "Address space for the NorthStar production virtual network."
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "aks_subnet_prefix" {
  description = "Address prefix for the production AKS subnet."
  type        = list(string)
  default     = ["10.20.1.0/24"]
}

variable "data_subnet_prefix" {
  description = "Address prefix for the production data subnet."
  type        = list(string)
  default     = ["10.20.2.0/24"]
}

variable "service_subnet_prefix" {
  description = "Address prefix for the production service subnet."
  type        = list(string)
  default     = ["10.20.3.0/24"]
}

variable "aks_nsg_name" {
  description = "Name of the production AKS network security group."
  type        = string
  default     = "nsg-aks-prod"
}

variable "data_nsg_name" {
  description = "Name of the production data network security group."
  type        = string
  default     = "nsg-data-prod"
}

variable "service_nsg_name" {
  description = "Name of the production service network security group."
  type        = string
  default     = "nsg-services-prod"
}


# --------------------------------------------------
# CONTAINER PLATFORM
# --------------------------------------------------

variable "acr_name" {
  description = "Name of the NorthStar production Azure Container Registry."
  type        = string
  default     = "northstarprodacr001"
}

variable "acr_sku" {
  description = "SKU for the NorthStar production Azure Container Registry."
  type        = string
  default     = "Basic"
}

variable "aks_name" {
  description = "Name of the NorthStar production AKS cluster."
  type        = string
  default     = "aks-northstar-prod"
}

variable "aks_dns_prefix" {
  description = "DNS prefix for the NorthStar production AKS cluster."
  type        = string
  default     = "northstar-prod"
}

variable "aks_identity_name" {
  description = "Name of the managed identity used by the production AKS cluster."
  type        = string
  default     = "id-aks-northstar-prod"
}

variable "aks_node_count" {
  description = "Number of nodes in the production AKS system node pool."
  type        = number
  default     = 2
}

variable "aks_vm_size" {
  description = "Virtual machine size used by production AKS nodes."
  type        = string
  default     = "Standard_D2s_v5"
}

variable "aks_pod_cidr" {
  description = "CIDR range used for production AKS pods."
  type        = string
  default     = "10.22.0.0/16"
}

variable "aks_service_cidr" {
  description = "CIDR range used for production Kubernetes services."
  type        = string
  default     = "10.21.0.0/16"
}

variable "aks_dns_service_ip" {
  description = "DNS service IP used by the production AKS cluster."
  type        = string
  default     = "10.21.0.10"
}


# --------------------------------------------------
# DATABASE
# --------------------------------------------------

variable "postgres_server_name" {
  description = "Name of the NorthStar production PostgreSQL Flexible Server."
  type        = string
  default     = "northstar-postgres-prod"
}

variable "postgres_database_name" {
  description = "Name of the NorthStar production PostgreSQL database."
  type        = string
  default     = "northstar_orders"
}

variable "postgres_admin_username" {
  description = "Administrator username for the production PostgreSQL Flexible Server."
  type        = string
  default     = "northstaradmin"
}

variable "postgres_admin_password" {
  description = "Administrator password for the production PostgreSQL Flexible Server."
  type        = string
  sensitive   = true
}

variable "postgres_version" {
  description = "PostgreSQL server version."
  type        = string
  default     = "16"
}

variable "postgres_sku_name" {
  description = "SKU used by the production PostgreSQL Flexible Server."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgres_storage_mb" {
  description = "Storage allocated to the production PostgreSQL Flexible Server in MB."
  type        = number
  default     = 32768
}

variable "postgres_backup_retention_days" {
  description = "Backup retention period for the production PostgreSQL server."
  type        = number
  default     = 7
}

variable "postgres_private_dns_zone_name" {
  description = "Name of the production PostgreSQL private DNS zone."
  type        = string
  default     = "northstar-prod.postgres.database.azure.com"
}

variable "postgres_private_dns_link_name" {
  description = "Name of the production PostgreSQL private DNS virtual network link."
  type        = string
  default     = "link-northstar-postgres-prod"
}


# --------------------------------------------------
# SECURITY
# --------------------------------------------------

variable "key_vault_name" {
  description = "Name of the NorthStar production Azure Key Vault."
  type        = string
  default     = "kv-northstar-prod-001"
}

variable "backend_identity_name" {
  description = "Name of the managed identity used by the NorthStar production backend."
  type        = string
  default     = "id-northstar-backend-prod"
}

variable "backend_namespace" {
  description = "Kubernetes namespace used by the NorthStar production backend."
  type        = string
  default     = "northstar"
}

variable "backend_service_account_name" {
  description = "Kubernetes service account used by the NorthStar production backend."
  type        = string
  default     = "northstar-backend"
}


# --------------------------------------------------
# MONITORING
# --------------------------------------------------

variable "log_analytics_workspace_name" {
  description = "Name of the NorthStar production Log Analytics workspace."
  type        = string
  default     = "log-northstar-prod"
}

variable "log_analytics_retention_days" {
  description = "Retention period for the NorthStar production Log Analytics workspace in days."
  type        = number
  default     = 30
}

variable "log_analytics_sku" {
  description = "SKU used by the NorthStar production Log Analytics workspace."
  type        = string
  default     = "PerGB2018"
}