output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.vnet.vnet_id
}

output "acr_login_server" {
  description = "Login server URL for the ACR"
  value       = module.acr.acr_login_server
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks_cluster.cluster_name
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${module.aks_cluster.cluster_name}"
}
