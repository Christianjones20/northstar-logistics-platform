variable "resource_group_name" {
  description = "Resource group containing the container platform"
  type = string
}

variable "location" {
    description = "Azure Region"
    type = string
}

variable "environment" {
    description = "Deployment Environment"
    type = string
}

variable "acr_name" {
    description = "Azure Container Registry Name"
    type = string
}

variable "acr_sku" {
    description = "Azure Container Registry SKU"
    type = string
}

variable "aks_name" {
    description = "AKS cluster name"
    type = string
}

variable "aks_dns_prefix" {
    description = "AKS DNS prefix"
    type = string
}

variable "aks_identity_name" {
    description = "AKS managed identity name"
    type = string
}

variable "aks_node_count" {
    description = "AkS system node count"
    type = number
}

variable "aks_vm_size"{
    description = "AKS node VM size"
    type =string
}
  
variable "aks_subnet_id" {
    description = "Subnet used by AKS"
    type = string
}

variable "aks_pod_cidr" {
    description = "AKS pod CIDR"
    type = string
}
  
  variable "aks_dns_service_ip" {
    description = "AKS Kubernettes DNS service IP"
    type =string
  }

 variable "log_analytics_workspace_id"{
   description = "Log Analytics workspace used by AKS monitoring"
   type = string
 }

variable "aks_service_cidr" {
  description = "AKS service CIDR"
  type        = string
}
