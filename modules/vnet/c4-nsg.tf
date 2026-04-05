# NSG for Private App Subnets
resource "azurerm_network_security_group" "private_app" {
  name                = "${var.name_prefix}-private-app-nsg"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    name                       = "AllowVNetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowAzureLoadBalancerInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyInternetInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-private-app-nsg"
  })
}

# NSG for Private Data Subnets
resource "azurerm_network_security_group" "private_data" {
  name                = "${var.name_prefix}-private-data-nsg"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    name                       = "AllowVNetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "DenyInternetInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-private-data-nsg"
  })
}

# Associate NSG with Private App Subnets
resource "azurerm_subnet_network_security_group_association" "private_app" {
  count                     = length(var.private_app_subnet_cidrs)
  subnet_id                 = azurerm_subnet.private_app[count.index].id
  network_security_group_id = azurerm_network_security_group.private_app.id
}

# Associate NSG with Private Data Subnets (individually named)
resource "azurerm_subnet_network_security_group_association" "private_data_mysql" {
  subnet_id                 = azurerm_subnet.private_data_mysql.id
  network_security_group_id = azurerm_network_security_group.private_data.id
}

resource "azurerm_subnet_network_security_group_association" "private_data_postgres" {
  subnet_id                 = azurerm_subnet.private_data_postgres.id
  network_security_group_id = azurerm_network_security_group.private_data.id
}

resource "azurerm_subnet_network_security_group_association" "private_data_general" {
  subnet_id                 = azurerm_subnet.private_data_general.id
  network_security_group_id = azurerm_network_security_group.private_data.id
}
