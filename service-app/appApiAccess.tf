# "API permissions" in Azure portal
# API acess for own scopes and roles if grant_own_api_access is true
resource "azuread_application_api_access" "self" {
  count = var.grant_own_api_access && (length(local.application_roles) > 0 || length(local.app_scopes)) > 0 ? 1 : 0

  application_id = azuread_application.main.id
  api_client_id  = azuread_application.main.client_id
  # permit api access for all own scopes/roles
  role_ids  = local.application_roles
  scope_ids = local.app_scopes
}

resource "azuread_application_api_access" "api_access" {
  for_each = var.api_access

  application_id = azuread_application.main.id
  api_client_id  = each.value.api_client_id

  # use role to assign application api access
  role_ids = [for role in each.value.api_roles :
    lookup(azuread_service_principal.apis[each.key].app_role_ids, role, null)
  ]

  # use scope to assign delegated api access
  scope_ids = [for scope in each.value.api_scopes :
    lookup(azuread_service_principal.apis[each.key].oauth2_permission_scope_ids, scope, null)
  ]
}

# required to read apis
resource "azuread_service_principal" "apis" {
  for_each     = var.api_access
  client_id    = each.value.api_client_id
  use_existing = true
}

# Grant admin consent for application permissions automatically
resource "azuread_app_role_assignment" "api_access" {
  for_each = local.api_role_assignments

  app_role_id         = lookup(azuread_service_principal.apis[each.value.api_key].app_role_ids, each.value.role_name, null)
  principal_object_id = azuread_service_principal.main.object_id
  resource_object_id  = azuread_service_principal.apis[each.value.api_key].object_id
}
