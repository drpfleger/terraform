# Resource Health Alert Module
# Uses the dedicated resource-health-alert module for monitoring
module "resource_health_alert" {
  count  = var.enable_resource_health_alert ? 1 : 0
  source = "github.com/drpfleger/terraform/resource-health-alert"

  subscription_id       = var.subscription_id
  project              = var.project
  environment          = var.environment
  resource_group_name  = data.azurerm_resource_group.main.name
  action_group_id      = azurerm_monitor_action_group.main.id
  resource_types       = var.health_alert_resource_types
  enable_health_alert  = true
}