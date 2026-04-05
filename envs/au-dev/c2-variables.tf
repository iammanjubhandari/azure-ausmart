variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "australiaeast"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "ausmart"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
}

variable "alert_email" {
  description = "Email address for alerts"
  type        = string
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "ausmart-aks"
}

variable "node_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "node_min_count" {
  description = "Minimum number of nodes for autoscaling"
  type        = number
  default     = 1
}

variable "node_max_count" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
  default     = 6
}

variable "node_count" {
  description = "Initial number of nodes"
  type        = number
  default     = 3
}

variable "enable_key_vault" {
  description = "Enable Key Vault provisioning"
  type        = bool
  default     = false
}

variable "enable_waf" {
  description = "Enable Web Application Firewall"
  type        = bool
  default     = false
}

variable "enable_high_availability" {
  description = "Enable high availability for databases"
  type        = bool
  default     = false
}

variable "db_sku_name" {
  description = "SKU name for database servers"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "redis_sku_name" {
  description = "SKU name for Redis cache"
  type        = string
  default     = "Basic"
}

variable "redis_family" {
  description = "Redis cache family"
  type        = string
  default     = "C"
}

variable "redis_capacity" {
  description = "Redis cache capacity"
  type        = number
  default     = 0
}

variable "monthly_budget" {
  description = "Monthly budget amount in USD"
  type        = string
  default     = "500"
}

variable "vnet_cidr" {
  description = "CIDR block for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private app subnets (passed to NSG for source rules)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS"
  type        = string
  default     = "1.31"
}
