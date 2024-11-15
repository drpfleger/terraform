data "azurerm_monitor_diagnostic_categories" "diag" {
  resource_id = var.target_resource_id
}

locals {
  category_groups = (
    var.user_defined_category_groups != null || var.user_defined_categories != null
    ? toset(var.user_defined_category_groups)
    : toset(data.azurerm_monitor_diagnostic_categories.diag.log_category_groups)
  )
  categories = (
    var.user_defined_categories != null || var.user_defined_category_groups != null
    ? toset(var.user_defined_categories)
    : toset(data.azurerm_monitor_diagnostic_categories.diag.log_category_types)
  )
  metrics = (
    var.user_defined_metrics != null
    ? toset(var.user_defined_metrics)
    : toset(data.azurerm_monitor_diagnostic_categories.diag.metrics)
  )

  # If a resource should be created can be defined with count property that requires an number value
  set_diagnostic_settings = var.enabled == true ? 1 : 0
}
