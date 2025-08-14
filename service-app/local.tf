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

  # Flatten api_access for app role assignments (application permissions only)
  api_role_assignments = {
    for assignment in flatten([
      for api_key, api_config in var.api_access : [
        for role in api_config.api_roles : {
          key           = "${api_key}-${role}"
          api_key       = api_key
          api_client_id = api_config.api_client_id
          role_name     = role
        }
      ]
    ]) : assignment.key => assignment
  }
}
