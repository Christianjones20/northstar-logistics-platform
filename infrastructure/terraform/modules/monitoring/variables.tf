# --------------------------------------------------
# GENERAL
# --------------------------------------------------

variable "resource_group_name" {
  description = "Name of the resource group containing the NorthStar monitoring resources."
  type        = string
}

variable "location" {
  description = "Azure region where the NorthStar monitoring resources are deployed."
  type        = string
}

variable "environment" {
  description = "Deployment environment for the NorthStar monitoring resources."
  type        = string
}


# --------------------------------------------------
# LOG ANALYTICS
# --------------------------------------------------

variable "log_analytics_workspace_name" {
  description = "Name of the NorthStar Log Analytics workspace."
  type        = string
}

variable "log_analytics_retention_days" {
  description = "Number of days to retain data in the NorthStar Log Analytics workspace."
  type        = number
}

variable "log_analytics_sku" {
  description = "SKU used by the NorthStar Log Analytics workspace."
  type        = string
}