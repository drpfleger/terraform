resource "azuread_app_role_assignment" "main" {
  for_each = local.enabled_assignments

  app_role_id = lookup(
    data.azuread_service_principal.resource.app_role_ids,
    each.value.app_role_value,
    null
  )

  principal_object_id = local.verified_principal_object_ids[each.key]
  resource_object_id  = data.azuread_service_principal.resource.object_id

  lifecycle {
    precondition {
      condition     = contains(keys(data.azuread_service_principal.resource.app_role_ids), each.value.app_role_value)
      error_message = "app_role_value must exist on the resource service principal."
    }
  }
}
