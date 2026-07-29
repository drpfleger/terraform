locals {
  required_tags = {
    project     = var.project
    environment = var.environment
    terraform   = "yes"
  }

  normalized_resource_ids = var.resource_ids == null ? [] : distinct([
    for resource_id in var.resource_ids : trimspace(resource_id)
  ])

  resource_id_provider_paths = [
    for resource_id in local.normalized_resource_ids : regexreplace(resource_id, "(?i)^/subscriptions/[^/]+/.*/providers/", "")
  ]

  derived_resource_types = sort(distinct([
    for provider_path in local.resource_id_provider_paths : join("/", [
      for index, segment in split("/", provider_path) : segment if index == 0 || index % 2 == 1
    ])
  ]))

  normalized_resource_types = var.resource_types == null ? [] : distinct([
    for resource_type in var.resource_types : trimspace(resource_type)
    if trimspace(resource_type) != ""
  ])

  merged_resource_types = sort(distinct(concat(local.normalized_resource_types, local.derived_resource_types)))

  effective_resource_types = length(local.merged_resource_types) > 0 ? local.merged_resource_types : null

  normalized_monitored_resource_groups = var.monitored_resource_groups == null ? null : distinct([
    for resource_group in var.monitored_resource_groups : trimspace(resource_group)
  ])

  resource_health_scope_resource_group  = var.resource_health_scope_mode == "resource_group" ? data.azurerm_resource_group.main.name : null
  resource_health_scope_resource_groups = var.resource_health_scope_mode == "resource_groups" ? local.normalized_monitored_resource_groups : null
}
