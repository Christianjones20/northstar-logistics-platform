variable "RESOURCE_GROUP_NAME" {
  description = "The name of the northstar resource group to create."
  type        = string
  default     = "rg-northstar-dev"
}

variable "LOCATION" {
  description = "The location of the northstar resource group to create."
  type        = string
  default     = "Central US"
}

variable "ENVIRONMENT" {
  description = "The environment to deploy the northstar resources to."
  type        = string
  default     = "dev"
}

variable "VNET_NAME" {
  description = "The name of the northstar virtual network to create."
  type        = string
  default     = "vnet-northstar-dev"
}

variable "VNET_ADDRESS_SPACE" {
  description = "The address space of the northstar virtual network to create."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "AKS_SUBNET_PREFIX" {
  description = "The prefix of the northstar AKS subnet to create."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "DATA_SUBNET_PREFIX" {
  description = "The prefix of the northstar data subnet to create."
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "SERVICE_SUBNET_PREFIX" {
  description = "The prefix of the northstar service subnet to create."
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

variable "AKS_NSG_NAME" {
  description = "The name of the northstar AKS NSG to create."
  type        = string
  default     = "nsg-northstar-aks-dev"
}

variable "DATA_NSG_NAME" {
  description = "The name of the northstar data NSG to create."
  type        = string
  default     = "nsg-northstar-data-dev"
}

variable "SERVICE_NSG_NAME" {
  description = "The name of the northstar service NSG to create."
  type        = string
  default     = "nsg-northstar-service-dev"
}
variable "ACR_NAME" {
  description = "The name of the northstar Azure Container Registry to create."
  type        = string
  default     = "Northstarlogisticsdevacr"
}

variable "ACR_SKU" {
  description = "The SKU of the northstar Azure Container Registry to create."
  type        = string
  default     = "Basic"
}

variable "AKS_CLUSTER_NAME" {
  description = "The name of the northstar AKS cluster to create."
  type        = string
  default     = "aks-northstar-dev"
}

variable "AKS_DNS_PREFIX" {
  description = "The DNS prefix of the northstar AKS cluster to create."
  type        = string
  default     = "northstar-dev"
}

variable "AKS_IDENTITY_NAME" {
  description = "The name of the northstar AKS managed identity to create."
  type        = string
  default     = "id-aks-northstar-dev"
}

variable "AKS_NODE_COUNT" {
  description = "The number of nodes in the northstar AKS cluster to create."
  type        = number
  default     = 1
}

variable "AKS_NODE_VM_SIZE" {
  description = "The size of the nodes in the northstar AKS cluster to create."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "AKS_POD_CIDR" {
  description = "The CIDR of the pods in the northstar AKS cluster to create."
  type        = string
  default     = "10.244.0.0/16"
}
variable "AKS_SERVICE_CIDR" {
  description = "The CIDR of the services in the northstar AKS cluster to create."
  type        = string
  default     = "10.20.0.0/16"
}

variable "AKS_DNS_SERVICE_IP" {
  description = "The DNS service IP of the northstar AKS cluster to create."
  type        = string
  default     = "10.20.0.10"
}

variable "postgres_server_name" {
  description = "The name of the northstar PostgreSQL server to create."
  type        = string
  default     = "northstar-dev-postgres-server"
}

variable "postgres_database_name" {
  description = "The name of the northstar PostgreSQL database to create."
  type        = string
  default     = "northstar_dev_db"
}

variable "postgres_admin_username" {
  description = "The admin username of the northstar PostgreSQL server to create."
  type        = string
  default     = "northstar_admin"
}

variable "postgres_admin_password" {
  description = "The admin password of the northstar PostgreSQL server to create."
  type        = string
  sensitive   = true
}

variable "key_vault_name" {
  description = "The name of the northstar Key Vault to create."
  type        = string
  default     = "kv-northstar-dev0001"
}

variable "backend_identity_name" {
  description = "The name of the northstar backend managed identity to create."
  type        = string
  default     = "id-backend-northstar-dev"
}

variable "backend_namespace" {
  description = "The namespace of the northstar backend to create."
  type        = string
  default     = "northstar-backend-dev"
}

variable "backend_service_account_name" {
  description = "The name of the northstar backend service account to create."
  type        = string
  default     = "sa-backend-northstar-dev"
}

variable "log_analytics_workspace_name" {
  description = "The name of the northstar Log Analytics workspace to create."
  type        = string
  default     = "law-northstar-dev"
}

variable "log_analytics_retention_in_days" {
  description = "The retention in days of the northstar Log Analytics workspace to create."
  type        = number
  default     = 30
}