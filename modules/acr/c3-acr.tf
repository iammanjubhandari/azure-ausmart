# Azure Container Registry
# NOTE: ACR name must be alphanumeric only (no hyphens)
resource "azurerm_container_registry" "main" {
  name                = replace(var.name_prefix, "-", "")
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-acr"
  })
}
