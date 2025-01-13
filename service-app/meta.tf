data "azuread_client_config" "current" {}

# read required apis
data "azuread_service_principal" "apis" {
  for_each  = var.api_access
  client_id = each.value.api_client_id
}

# read key vault of this project + stage
data "azurerm_key_vault" "main" {
  name                = local.kvt_name
  resource_group_name = local.rg_name
}

# read this projects admin group name
data "azuread_group" "project_admin_group" {
  display_name = local.admin_group_name
}
