data "azuread_client_config" "current" {}

# read required apis
data "azuread_service_principal" "apis" {
  for_each  = var.api_access
  client_id = each.value.api_client_id
}

# read the given key vault to store secrets
# set to default value in naming if not differently set in module call
# Goal is not having to set values in most cases, only edge cases where naming conventions are not followed
data "azurerm_key_vault" "main" {
  name                = var.kvt_name != "default" ? var.kvt_name : local.default_kvt_name
  resource_group_name = var.rg_name != "default" ? var.rg_name : local.default_rg_name
}

# read this projects admin group name
data "azuread_group" "project_admin_group" {
  display_name = local.admin_group_name
}
