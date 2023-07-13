# State Storage
# this is not part of the pipeline and have to be applied manually
resource "azurerm_storage_account" "main" {
  name                     = local.storage_account_name
  is_hns_enabled           = false
  account_kind             = "StorageV2"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# create storage container
resource "azurerm_storage_container" "state" {
  name                 = local.container_name
  storage_account_name = azurerm_storage_account.main.name
}
