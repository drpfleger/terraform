data "azuread_client_config" "current" {}

# read required apis
data "azuread_service_principal" "apis" {
  for_each  = var.api_access
  client_id = each.value.api_client_id
}

# read this projects admin group name
data "azuread_group" "project_admin_group" {
  display_name = local.admin_group_name
}
