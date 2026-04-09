output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.id
}

output "kube_config_raw" {
  description = "Raw kubeconfig for the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "host" {
  description = "Kubernetes API server host"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].host
  sensitive   = true
}

output "client_certificate" {
  description = "Client certificate for authentication"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
  sensitive   = true
}

output "client_key" {
  description = "Client key for authentication"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_key
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Cluster CA certificate"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
  sensitive   = true
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for workload identity"
  value       = azurerm_kubernetes_cluster.main.oidc_issuer_url
}

output "kubelet_identity_object_id" {
  description = "Object ID of the kubelet managed identity"
  value       = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

output "key_vault_secrets_provider_identity" {
  description = "Identity of the Key Vault secrets provider"
  value       = azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0].secret_identity[0].object_id
}
