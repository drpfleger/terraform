# State Storage
# this is not part of the pipeline and have to be applied manually
resource "azurerm_storage_account" "main" {
  name                            = var.override_storage_account_name != null ? var.override_storage_account_name : local.storage_account_name
  is_hns_enabled                  = false
  account_kind                    = "StorageV2"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = var.allow_blob_anonymous_access


  blob_properties {
    dynamic "delete_retention_policy" {
      for_each = var.delete_retention_blob_in_days != null ? [1] : []
      content {
        days = var.delete_retention_blob_in_days
      }
    }

    dynamic "container_delete_retention_policy" {
      for_each = var.delete_retention_container_in_days != null ? [1] : []
      content {
        days = var.delete_retention_blob_in_days
      }
    }
  }
}

# create storage container
resource "azurerm_storage_container" "state" {
  name               = local.container_name
  storage_account_id = azurerm_storage_account.main.id
}
