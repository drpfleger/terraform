resource "azuread_group" "admin_group" {
  display_name       = local.admin_group_name
  mail_enabled       = false
  security_enabled   = true
  assignable_to_role = var.group_assignable_to_role
}

# Assign the created project admin group a role on the subscription level
resource "azurerm_role_assignment" "admin_group_subscription_owner" {
  scope                = "subscriptions/${data.azurerm_client_config.main.subscription_id}"
  role_definition_name = var.admin_group_role
  principal_id         = azuread_group.admin_group.object_id
}
