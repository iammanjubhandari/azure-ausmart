# =============================================================================
# Module Orchestration — au-dev
#
# DEPENDENCY ORDER:
#   Resource Group (c3-locals.tf)
#     ├── VNet, ACR, Monitoring (Tier 1 — independent, parallel)
#     └── AKS Cluster (Tier 2 — needs VNet + ACR + Monitoring)
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

# =============================================================================
# TIER 2: Depends on VNet + ACR + Monitoring
# =============================================================================

# --- AKS Cluster (needs VNet subnets, ACR for pull, Log Analytics for monitoring) ---

module "aks_cluster" {
  source = "../../modules/aks-cluster"

  name_prefix                = local.name_prefix
  common_tags                = local.common_tags
  resource_group_name        = azurerm_resource_group.main.name
  location                   = var.location
  cluster_name               = var.cluster_name
  kubernetes_version         = var.kubernetes_version
  private_app_subnet_ids     = module.vnet.private_app_subnet_ids
  node_vm_size               = var.node_vm_size
  node_min_count             = var.node_min_count
  node_max_count             = var.node_max_count
  node_count                 = var.node_count
  acr_id                     = module.acr.acr_id
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  enable_monitoring          = true

  depends_on = [module.vnet, module.acr, module.monitoring]
}
