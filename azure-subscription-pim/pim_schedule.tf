# Privileged Access Group Eligibility:
# Assign eligible groups to allow activation of role "member" in privileged groups.
# This "eligible" assignment does not expire, but activation of the membership in the privileged group
# is subject to the policy defined in the azuread_group_role_management_policy resource.

resource "azuread_privileged_access_group_eligibility_schedule" "pim_eligibility_schedule" {
  group_id             = data.azuread_group.pim_privileged_group.object_id
  principal_id         = azuread_group.pim_eligible_group.object_id
  assignment_type      = "member"
  permanent_assignment = true
  justification        = "Terraform group eligibility schedule"

  depends_on = [azuread_group_role_management_policy.pim_member_policy]
}

resource "azuread_privileged_access_group_assignment_schedule" "pim_assignment_schedule" {
  for_each = toset(var.active_members)

  group_id             = data.azuread_group.pim_privileged_group.object_id
  principal_id         = data.azuread_user.pim_members[each.value].object_id
  assignment_type      = "member"
  permanent_assignment = true
  justification        = "Terraform active member assignment"

  depends_on = [azuread_group_role_management_policy.pim_member_policy]
}
