data "azurerm_resource_group" "main" {
  name = var.main_resource_group_name
}

data "azurerm_subscription" "main" {
  subscription_id = var.subscription_id
}

data "azurerm_client_config" "main" {
}
