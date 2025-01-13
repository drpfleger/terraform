locals {
  app_scopes = values(azuread_application_permission_scope.main)[*].scope_id
  application_roles = [
    for role in azuread_application_app_role.main :
    role.role_id
    if contains(role.allowed_member_types, "Application")
  ]
  user_roles = [
    for role in azuread_application_app_role.main :
    role.role_id
    if contains(role.allowed_member_types, "User")
  ]
}
