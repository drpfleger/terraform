resource "azurerm_network_watcher" "main" {
  name                = local.network_watcher_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = local.required_tags
}
