# User Node Pool for Application Workloads
resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = var.node_vm_size
  node_count            = var.node_count
  min_count             = var.node_min_count
  max_count             = var.node_max_count
  auto_scaling_enabled  = true
  vnet_subnet_id        = var.private_app_subnet_ids[0]
  os_disk_size_gb       = 30

  node_labels = {
    "workload" = "app"
  }

  tags = merge(var.common_tags, {
    Name = "${var.cluster_name}-user-nodepool"
  })
}
