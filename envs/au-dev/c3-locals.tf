locals {
  name_prefix         = "${var.project_name}-${var.environment}"
  resource_group_name = "${var.project_name}-${var.environment}-rg"

  base_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = var.owner
    Region      = var.location
  }

  common_tags = local.base_tags
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location

  tags = local.common_tags
}
