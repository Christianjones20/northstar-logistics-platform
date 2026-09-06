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