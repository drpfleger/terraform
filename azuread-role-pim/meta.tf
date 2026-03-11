# Read all unique users for each group by user principal name
data "azuread_user" "pim_members" {
  for_each = setunion(toset(var.eligible_members), toset(var.active_members))

  user_principal_name = each.value
}

data "azuread_user" "pim_approvers" {
  for_each = toset(var.approver_members)

  user_principal_name = each.value
}
