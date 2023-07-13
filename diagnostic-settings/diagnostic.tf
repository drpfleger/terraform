resource "azurerm_monitor_diagnostic_setting" "diagnostic" {
  count                      = local.set_diagnostic_settings
  name                       = var.diagnostic_name
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.main.id

  dynamic "enabled_log" {
    for_each = local.category_types == null ? [] : local.category_types
    content {
      category = enabled_log.value

      retention_policy {
        enabled = false
      }
    }
  }

  dynamic "metric" {
    for_each = local.metrics == null ? [] : local.metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = false
      }
    }
  }
}
