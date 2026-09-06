variable "resource_group_name" {
  description = "Resource group containing NorthStar networking resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space of the virtual network"
  type        = list(string)
}

variable "aks_subnet_prefix" {
  description = "Address prefix for the AKS subnet"
  type        = list(string)
}

variable "data_subnet_prefix" {
  description = "Address prefix for the data subnet"
  type        = list(string)
}

variable "service_subnet_prefix" {
  description = "Address prefix for the service subnet"
  type        = list(string)
}

variable "aks_nsg_name" {
  description = "Name of the AKS Network Security Group"
  type        = string
}

variable "data_nsg_name" {
  description = "Name of the data Network Security Group"
  type        = string
}

variable "service_nsg_name" {
  description = "Name of the service Network Security Group"
  type        = string
}