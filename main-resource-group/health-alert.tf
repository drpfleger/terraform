# Resource Health Alert Module
# Uses the dedicated resource-health-alert module for monitoring
module "resource_health_alert" {
  count  = var.enable_resource_health_alert || var.enable_service_health_alert ? 1 : 0
  source = "github.com/drpfleger/terraform/resource-health-alert"

  subscription_id              = var.subscription_id
  project                      = var.project
  environment                  = var.environment
  resource_group_name          = data.azurerm_resource_group.main.name
  action_group_id              = azurerm_monitor_action_group.main.id
  resource_types               = var.health_alert_resource_types
  create_resource_health_alert = var.enable_resource_health_alert
  enable_health_alert          = var.enable_resource_health_alert
  resource_health_scope_mode   = var.health_alert_scope_mode
  monitored_resource_groups    = var.health_alert_resource_groups
  enable_service_health_alert  = var.enable_service_health_alert
  service_health_events        = var.health_alert_service_events
  service_health_services      = var.health_alert_service_services
  service_health_locations     = var.health_alert_service_locations
}
