locals {
  enabled_assignments = {
    for assignment_name, assignment in var.app_role_assignments :
    assignment_name => assignment
    if assignment.enabled
  }

  group_assignments = {
    for assignment_name, assignment in local.enabled_assignments :
    assignment_name => assignment
    if assignment.principal_type == "Group"
  }

  user_assignments = {
    for assignment_name, assignment in local.enabled_assignments :
    assignment_name => assignment
    if assignment.principal_type == "User"
  }

  service_principal_assignments = {
    for assignment_name, assignment in local.enabled_assignments :
    assignment_name => assignment
    if assignment.principal_type == "ServicePrincipal"
  }

  verified_principal_object_ids = merge(
    { for assignment_name, principal in data.azuread_group.principal : assignment_name => principal.object_id },
    { for assignment_name, principal in data.azuread_user.principal : assignment_name => principal.object_id },
    { for assignment_name, principal in data.azuread_service_principal.principal : assignment_name => principal.object_id }
  )
}
