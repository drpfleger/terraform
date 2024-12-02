resource "azurerm_monitor_activity_log_alert" "default_health_status" {
  name                = local.alert_rule_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  enabled             = var.enable_health_alert

  scopes = [
    var.subscription_id
  ]

  criteria {
    category       = "ResourceHealth"
    resource_group = data.azurerm_resource_group.main.name
    resource_types = var.resource_types == null ? local.resource_types : var.resource_types


    resource_health {
      current  = ["Degraded", "Unavailable"]
      previous = ["Available"]
    }
  }

  action {
    action_group_id = var.action_group_id
  }
}
