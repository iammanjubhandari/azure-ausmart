# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                          = var.cluster_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  dns_prefix                    = var.cluster_name
  kubernetes_version            = var.kubernetes_version
  public_network_access_enabled = true

  default_node_pool {
    name                         = "system"
    vm_size                      = var.node_vm_size
    node_count                   = var.node_count
    min_count                    = var.node_min_count
    max_count                    = var.node_max_count
    auto_scaling_enabled         = true
    vnet_subnet_id               = var.private_app_subnet_ids[0]
    os_disk_size_gb              = 30
    os_disk_type                 = "Managed"
    type                         = "VirtualMachineScaleSets"
    temporary_name_for_rotation  = "systemtmp"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"    # Azure CNI + Azure Network Policy (supported combo)
    service_cidr   = "172.16.0.0/16"
    dns_service_ip = "172.16.0.10"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  azure_policy_enabled      = true

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  dynamic "oms_agent" {
    for_each = var.enable_monitoring && var.log_analytics_workspace_id != "" ? [1] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  tags = merge(var.common_tags, {
    Name = var.cluster_name
  })
}
