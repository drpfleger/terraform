# get resource group of log analytics workspace
data "azurerm_resource_group" "log_resource_group" {
  provider = azurerm.monitoring_subscription
  name     = var.log_analytics_resource_group
}

# get log analytics workspace
data "azurerm_log_analytics_workspace" "main" {
  provider = azurerm.monitoring_subscription
  depends_on = [
    data.azurerm_resource_group.log_resource_group
  ]
  name                = var.log_analytics_name
  resource_group_name = data.azurerm_resource_group.log_resource_group.name
}
