# --------------------------------------------------
# GENERAL
# --------------------------------------------------

variable "resource_group_name" {
  description = "Name of the resource group containing the NorthStar security resources."
  type        = string
}

variable "location" {
  description = "Azure region where the NorthStar security resources are deployed."
  type        = string
}

variable "environment" {
  description = "Deployment environment for the NorthStar security resources."
  type        = string
}


# --------------------------------------------------
# IDENTITY
# --------------------------------------------------

variable "tenant_id" {
  description = "Microsoft Entra tenant ID."
  type        = string
}

variable "terraform_operator_object_id" {
  description = "Object ID of the identity running Terraform."
  type        = string
}

variable "backend_identity_name" {
  description = "Name of the managed identity used by the NorthStar backend workload."
  type        = string
}


# --------------------------------------------------
# KEY VAULT
# --------------------------------------------------

variable "key_vault_name" {
  description = "Name of the NorthStar Azure Key Vault."
  type        = string
}


# --------------------------------------------------
# AKS WORKLOAD IDENTITY
# --------------------------------------------------

variable "aks_oidc_issuer_url" {
  description = "OIDC issuer URL for the NorthStar AKS cluster."
  type        = string
}

variable "backend_namespace" {
  description = "Kubernetes namespace containing the NorthStar backend workload."
  type        = string
}

variable "backend_service_account_name" {
  description = "Kubernetes service account used by the NorthStar backend workload."
  type        = string
}