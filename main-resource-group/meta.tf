data "azurerm_resource_group" "main" {
  name = var.main_resource_group_name
}

data "azurerm_subscription" "main" {
  subscription_id = var.subscription_id
}

data "azurerm_storage_account" "state" {
  name                = var.override_storage_account_name != null ? var.override_storage_account_name : local.state_storage_account_name
  resource_group_name = data.azurerm_resource_group.main.name
}
