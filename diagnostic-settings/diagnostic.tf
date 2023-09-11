resource "azurerm_monitor_diagnostic_setting" "diagnostic" {
  count                          = local.set_diagnostic_settings
  name                           = var.diagnostic_name
  target_resource_id             = var.target_resource_id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.main.id
  log_analytics_destination_type = var.destination_type

  dynamic "enabled_log" {
    for_each = local.category_types == null ? [] : local.category_types
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = local.metrics == null ? [] : local.metrics
    content {
      category = metric.value
      enabled  = true
    }
  }
}
