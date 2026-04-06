# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.name_prefix}-log-analytics"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-log-analytics"
  })
}

# Monitor Action Group
resource "azurerm_monitor_action_group" "main" {
  name                = "${var.name_prefix}-action-group"
  resource_group_name = var.resource_group_name
  short_name          = "alerts"

  email_receiver {
    name          = "admin"
    email_address = var.alert_email
  }

  tags = var.common_tags
}

# Resource Group Budget
resource "azurerm_consumption_budget_resource_group" "main" {
  name              = "${var.name_prefix}-monthly-budget"
  resource_group_id = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.resource_group_name}"

  amount     = tonumber(var.monthly_budget)
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00Z", timestamp())
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThan"
    threshold_type = "Actual"

    contact_groups = [azurerm_monitor_action_group.main.id]
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Actual"

    contact_groups = [azurerm_monitor_action_group.main.id]
  }

  lifecycle {
    ignore_changes = [time_period]
  }
}

# Data source for current subscription
data "azurerm_subscription" "current" {}
