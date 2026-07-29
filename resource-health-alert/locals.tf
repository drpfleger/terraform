locals {
  required_tags = {
    project     = var.project
    environment = var.environment
    terraform   = "yes"
  }

  normalized_monitored_resource_groups = var.monitored_resource_groups == null ? null : distinct([
    for resource_group in var.monitored_resource_groups : trimspace(resource_group)
  ])

  resource_health_scope_resource_group  = var.resource_health_scope_mode == "resource_group" ? data.azurerm_resource_group.main.name : null
  resource_health_scope_resource_groups = var.resource_health_scope_mode == "resource_groups" ? local.normalized_monitored_resource_groups : null
}
