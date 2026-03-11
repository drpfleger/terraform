# Group for which to enable PIM
data "azuread_group" "pim_privileged_group" {
  display_name = var.admin_group_name
}

# Read all unique users for each group by user principal name
data "azuread_user" "pim_members" {
  for_each = setunion(toset(var.eligible_members), toset(var.active_members))

  user_principal_name = each.value
}
