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
    lookup(data.azuread_service_principal.apis[each.key].app_role_ids, role, null)
  ]

  # use scope to assign delegated api access
  scope_ids = [for scope in each.value.api_scopes :
    lookup(data.azuread_service_principal.apis[each.key].oauth2_permission_scope_ids, scope, null)
  ]
}
