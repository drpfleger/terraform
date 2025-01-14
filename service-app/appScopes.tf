# Define OAuth2 permission scopes that client applications can request access to in the name of the user
resource "azuread_application_permission_scope" "main" {
  for_each = var.oauth2_scopes

  application_id = azuread_application.main.id
  scope_id       = random_uuid.scope_ids[each.key].id # random, valid UUID

  admin_consent_display_name = each.value.admin_consent_display_name
  admin_consent_description  = each.value.admin_consent_description
  user_consent_display_name  = each.value.user_consent_display_name
  user_consent_description   = each.value.user_consent_description
  value                      = each.value.scope_value
  type                       = each.value.scope_type
}

# each scope requires a valid UUID, generate one with random_uuid
resource "random_uuid" "scope_ids" {
  for_each = var.oauth2_scopes
}
