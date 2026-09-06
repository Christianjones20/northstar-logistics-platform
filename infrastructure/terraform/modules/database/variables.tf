variable "resource_group_name" {
  description = "Resource group containing database resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vnet_id" {
  description = "Virtual network ID used for PostgreSQL private DNS"
  type        = string
}

variable "data_subnet_id" {
  description = "Delegated subnet used by PostgreSQL Flexible Server"
  type        = string
}

variable "private_dns_zone_name" {
  description = "Private DNS zone used by PostgreSQL"
  type        = string
}

variable "private_dns_link_name" {
  description = "Name of the PostgreSQL private DNS VNet link"
  type        = string
}

variable "postgres_server_name" {
  description = "PostgreSQL Flexible Server name"
  type        = string
}

variable "postgres_database_name" {
  description = "Application database name"
  type        = string
}

variable "postgres_admin_username" {
  description = "PostgreSQL administrator username"
  type        = string
}

variable "postgres_admin_password" {
  description = "PostgreSQL administrator password"
  type        = string
  sensitive   = true
}

variable "postgres_version" {
  description = "PostgreSQL major version"
  type        = string
}

variable "postgres_sku_name" {
  description = "PostgreSQL Flexible Server SKU"
  type        = string
}

variable "postgres_storage_mb" {
  description = "PostgreSQL storage capacity in MB"
  type        = number
}

variable "postgres_backup_retention_days" {
  description = "PostgreSQL backup retention period"
  type        = number
}