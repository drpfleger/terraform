resource "azuread_group" "admin_group" {
  display_name       = local.admin_group_name
  mail_enabled       = false
  security_enabled   = true
  assignable_to_role = var.group_assignable_to_role
}

# Assign the created project admin group a role on the subscription level
resource "azurerm_role_assignment" "admin_group_subscription_role" {
  scope                = data.azurerm_subscription.main.id
  role_definition_name = var.admin_group_role
  principal_id         = azuread_group.admin_group.object_id
}

resource "azurerm_role_assignment" "state_storage_account_role" {
  count                = var.allow_admins_read_state_storage_account ? 1 : 0
  scope                = data.azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azuread_group.admin_group.object_id
}

resource "azurerm_role_assignment" "state_storage_account_key_operator" {
  count                = var.allow_admins_read_state_storage_account ? 1 : 0
  scope                = data.azurerm_storage_account.state.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azuread_group.admin_group.object_id
}
