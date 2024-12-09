# Purpose: Create an activity log alert for resource health status
# if no resources are there to monitor, the alert will not be created
resource "azurerm_monitor_activity_log_alert" "default_health_status" {
  name                = local.alert_rule_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  enabled             = var.enable_health_alert

  scopes = [
    "/subscriptions/${var.subscription_id}"
  ]

  criteria {
    category       = "ResourceHealth"
    resource_group = data.azurerm_resource_group.main.name
    resource_types = var.resource_types

    resource_health {
      current  = ["Degraded", "Unavailable"]
      previous = ["Available"]
    }
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = local.required_tags
}
