# Purpose: Create an activity log alert for resource health status.
resource "azurerm_monitor_activity_log_alert" "default_health_status" {
  count               = var.create_resource_health_alert ? 1 : 0
  name                = local.alert_rule_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  enabled             = var.enable_health_alert

  scopes = [
    "/subscriptions/${var.subscription_id}"
  ]

  criteria {
    category        = "ResourceHealth"
    resource_group  = local.resource_health_scope_resource_group
    resource_groups = local.resource_health_scope_resource_groups
    resource_types  = local.effective_resource_types

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
