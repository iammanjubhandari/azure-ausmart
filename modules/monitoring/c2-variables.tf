variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "alert_email" {
  description = "Email address for alerts"
  type        = string
}

variable "monthly_budget" {
  description = "Monthly budget amount in USD"
  type        = string
  default     = "500"
}
