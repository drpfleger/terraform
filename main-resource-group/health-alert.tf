# Resource Health Alert
# Creates an activity log alert for resource health status monitoring
resource "azurerm_monitor_activity_log_alert" "health" {
  count               = var.enable_resource_health_alert ? 1 : 0
  name                = local.health_alert_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  enabled             = true

  scopes = [
    "/subscriptions/${var.subscription_id}"
  ]

  criteria {
    category       = "ResourceHealth"
    resource_group = data.azurerm_resource_group.main.name
    resource_types = var.health_alert_resource_types

    resource_health {
      current  = ["Degraded", "Unavailable"]
      previous = ["Available"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.main[0].id
  }

  tags = local.required_tags
}