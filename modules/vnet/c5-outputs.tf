output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = azurerm_subnet.public[*].id
}

output "private_app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = azurerm_subnet.private_app[*].id
}

output "private_data_mysql_subnet_id" {
  description = "ID of the MySQL delegated subnet"
  value       = azurerm_subnet.private_data_mysql.id
}

output "private_data_postgres_subnet_id" {
  description = "ID of the PostgreSQL delegated subnet"
  value       = azurerm_subnet.private_data_postgres.id
}

output "private_data_general_subnet_id" {
  description = "ID of the general data subnet (Redis, etc)"
  value       = azurerm_subnet.private_data_general.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = var.enable_nat_gateway ? azurerm_nat_gateway.main[0].id : null
}
