# Privileged groups, these groups are role assignable
resource "azuread_group" "pim_privileged_group" {
  display_name            = "SGU_PIM_${var.privilege_level}Priv_${var.configuration_name}"
  security_enabled        = true
  assignable_to_role      = true
  prevent_duplicate_names = true
}

# Group containing eligible users, not role assignable
resource "azuread_group" "pim_eligible_group" {
  display_name            = "SGU_PIM_${var.privilege_level}Priv_${var.configuration_name}_Eligible"
  security_enabled        = true
  prevent_duplicate_names = true
  members                 = local.object_ids_eligible
}

# Create additional groups this privileged group should be added to as a member.
# This allows granular access control in other portals, like Intune. On activation
# into PIM priv. group the user becomes a member of the additional groups as well.
resource "azuread_group" "pim_additional_group" {
  for_each = toset(var.additional_group_membership)

  display_name            = each.key
  security_enabled        = true
  prevent_duplicate_names = true
  members                 = [azuread_group.pim_privileged_group.object_id]
}

# Group containing approver users, not role assignable
resource "azuread_group" "pim_approver_group" {
  count = length(var.approver_members) > 0 ? 1 : 0

  display_name            = "SGU_PIM_${var.privilege_level}Priv_${var.configuration_name}_Approvers"
  security_enabled        = true
  prevent_duplicate_names = true
  members                 = local.object_ids_approvers
}
