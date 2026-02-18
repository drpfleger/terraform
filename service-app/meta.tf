data "azuread_client_config" "current" {}

# read this projects admin group name
data "azuread_group" "project_admin_group" {
  display_name = local.admin_group_name
}
