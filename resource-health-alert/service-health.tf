# Purpose: Create an activity log alert for Azure Service Health events.
resource "azurerm_monitor_activity_log_alert" "default_service_health_status" {
  count               = var.enable_service_health_alert ? 1 : 0
  name                = local.service_health_alert_rule_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = "Global"
  enabled             = true

  scopes = [
    "/subscriptions/${var.subscription_id}"
  ]

  criteria {
    category = "ServiceHealth"

    service_health {
      events    = var.service_health_events
      services  = var.service_health_services
      locations = var.service_health_locations
    }
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = local.required_tags
}
