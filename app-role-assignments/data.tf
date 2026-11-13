data "azuread_service_principal" "resource" {
  object_id = var.resource_service_principal_object_id
}

data "azuread_group" "principal" {
  for_each = local.group_assignments

  object_id = each.value.principal_object_id
}

data "azuread_user" "principal" {
  for_each = local.user_assignments

  object_id = each.value.principal_object_id
}

data "azuread_service_principal" "principal" {
  for_each = local.service_principal_assignments

  object_id = each.value.principal_object_id
}
