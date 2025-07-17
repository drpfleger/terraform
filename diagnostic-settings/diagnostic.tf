resource "azurerm_monitor_diagnostic_setting" "diagnostic" {
  provider                       = azurerm.target
  count                          = local.set_diagnostic_settings
  name                           = var.diagnostic_name
  target_resource_id             = var.target_resource_id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.main.id
  log_analytics_destination_type = var.destination_type == "Skip" ? null : var.destination_type

  dynamic "enabled_log" {
    for_each = local.category_groups == null ? [] : local.category_groups
    content {
      category_group = enabled_log.value
    }
  }

  dynamic "enabled_log" {
    for_each = local.category_groups == null ? (local.categories == null ? [] : local.categories) : []
    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = local.metrics == null ? [] : local.metrics
    content {
      category = enabled_metric.value
      enabled  = true
    }
  }
}
