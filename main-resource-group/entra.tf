resource "azuread_group" "admin_group" {
  display_name       = local.admin_group_name
  mail_enabled       = false
  security_enabled   = true
  assignable_to_role = var.group_assignable_to_role
}
