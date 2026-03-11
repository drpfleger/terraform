# Directory roles for this group's roles
resource "azuread_directory_role" "pim_roles" {
  for_each = toset(var.roles)

  display_name = each.value
}

# Assign directory role to this privileged group by looping over the roles variable
resource "azuread_directory_role_assignment" "group_roles_assignments" {
  for_each = toset(var.roles)

  principal_object_id = azuread_group.pim_privileged_group.object_id
  role_id             = azuread_directory_role.pim_roles[each.value].template_id
}
