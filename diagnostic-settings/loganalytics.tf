# get resource group of log analytics workspace
data "azurerm_resource_group" "log_resource_group" {
  provider = azurerm.log_analytics
  name     = var.log_analytics_resource_group
}

# get log analytics workspace
data "azurerm_log_analytics_workspace" "main" {
  provider = azurerm.log_analytics
  depends_on = [
    data.azurerm_resource_group.log_resource_group
  ]
  name                = var.log_analytics_name
  resource_group_name = data.azurerm_resource_group.log_resource_group.name
}
