# =============================================================================
# Module Orchestration — au-dev
# Modules are added here as they're built. VNet first, rest follows.
# =============================================================================

# --- VNet (everything needs this) ---

module "vnet" {
  source = "../../modules/vnet"

  name_prefix         = local.name_prefix
  common_tags         = local.common_tags
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  vnet_cidr           = var.vnet_cidr
  cluster_name        = var.cluster_name
}

# --- ACR (AKS needs this for image pulls) ---

module "acr" {
  source = "../../modules/acr"

  name_prefix         = local.name_prefix
  common_tags         = local.common_tags
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
}

# --- Monitoring (AKS needs Log Analytics workspace ID) ---

module "monitoring" {
  source = "../../modules/monitoring"

  name_prefix         = local.name_prefix
  common_tags         = local.common_tags
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  alert_email         = var.alert_email
  monthly_budget      = var.monthly_budget
}
