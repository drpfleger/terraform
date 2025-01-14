# Define Application roles for use by application.
# blade "App roles" in Azure portal. "User" and "Application" are allowed member types.
resource "azuread_application_app_role" "main" {
  for_each = var.app_roles

  application_id = azuread_application.main.id
  role_id        = random_uuid.role_ids[each.key].id # random, valid UUID

  allowed_member_types = each.value.allowed_member_types
  display_name         = each.value.display_name
  description          = each.value.description
  value                = each.value.value
}

# each scope requires a valid UUID, generate one with random_uuid
resource "random_uuid" "role_ids" {
  for_each = var.app_roles
}
