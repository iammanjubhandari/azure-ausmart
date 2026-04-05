# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.name_prefix}-vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = [var.vnet_cidr]

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-vnet"
  })
}

# Public Subnets
resource "azurerm_subnet" "public" {
  count                = length(var.public_subnet_cidrs)
  name                 = "${var.name_prefix}-public-subnet-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_cidrs[count.index]]
}

# Private Application Subnets (EKS nodes)
resource "azurerm_subnet" "private_app" {
  count                = length(var.private_app_subnet_cidrs)
  name                 = "${var.name_prefix}-private-app-subnet-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_app_subnet_cidrs[count.index]]

  service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
}

# Private Data Subnet — MySQL (requires dedicated subnet with delegation)
resource "azurerm_subnet" "private_data_mysql" {
  name                 = "${var.name_prefix}-private-data-mysql"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_data_subnet_cidrs[0]]

  delegation {
    name = "mysql-delegation"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Private Data Subnet — PostgreSQL (requires dedicated subnet with delegation)
resource "azurerm_subnet" "private_data_postgres" {
  name                 = "${var.name_prefix}-private-data-postgres"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_data_subnet_cidrs[1]]

  delegation {
    name = "postgres-delegation"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Private Data Subnet — Redis + other (no delegation needed)
resource "azurerm_subnet" "private_data_general" {
  name                 = "${var.name_prefix}-private-data-general"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_data_subnet_cidrs[2]]
}

# TODO: need NSG rules for private subnets - currently wide open

# NAT Gateway Public IP
resource "azurerm_public_ip" "nat" {
  count               = var.enable_nat_gateway ? 1 : 0
  name                = "${var.name_prefix}-nat-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-nat-pip"
  })
}

# NAT Gateway
resource "azurerm_nat_gateway" "main" {
  count                   = var.enable_nat_gateway ? 1 : 0
  name                    = "${var.name_prefix}-nat-gw"
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-nat-gw"
  })
}

# NAT Gateway Public IP Association
resource "azurerm_nat_gateway_public_ip_association" "main" {
  count                = var.enable_nat_gateway ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.main[0].id
  public_ip_address_id = azurerm_public_ip.nat[0].id
}

# NAT Gateway Association for Private App Subnets
resource "azurerm_subnet_nat_gateway_association" "private_app" {
  count          = var.enable_nat_gateway ? length(var.private_app_subnet_cidrs) : 0
  subnet_id      = azurerm_subnet.private_app[count.index].id
  nat_gateway_id = azurerm_nat_gateway.main[0].id
}

# NAT Gateway Association for Private Data Subnets (individually named, not count-indexed)
resource "azurerm_subnet_nat_gateway_association" "private_data_mysql" {
  count          = var.enable_nat_gateway ? 1 : 0
  subnet_id      = azurerm_subnet.private_data_mysql.id
  nat_gateway_id = azurerm_nat_gateway.main[0].id
}

resource "azurerm_subnet_nat_gateway_association" "private_data_postgres" {
  count          = var.enable_nat_gateway ? 1 : 0
  subnet_id      = azurerm_subnet.private_data_postgres.id
  nat_gateway_id = azurerm_nat_gateway.main[0].id
}

resource "azurerm_subnet_nat_gateway_association" "private_data_general" {
  count          = var.enable_nat_gateway ? 1 : 0
  subnet_id      = azurerm_subnet.private_data_general.id
  nat_gateway_id = azurerm_nat_gateway.main[0].id
}
