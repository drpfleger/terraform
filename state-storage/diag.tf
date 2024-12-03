## State Storage
module "monitoring_state_storage" {
  count = var.use_diagnostic_settings ? 1 : 0
  providers = {
    azurerm.target        = azurerm,
    azurerm.log_analytics = azurerm.log_analytics
  }

  source                       = "github.com/drpfleger/terraform/diagnostic-settings"
  target_resource_id           = azurerm_storage_account.main.id
  log_analytics_name           = var.log_analytics_name
  log_analytics_resource_group = var.log_analytics_resource_group
}

# BlobService
module "monitoring_state_blob" {
  count = var.use_diagnostic_settings ? 1 : 0

  providers = {
    azurerm.target        = azurerm,
    azurerm.log_analytics = azurerm.log_analytics
  }

  source                       = "github.com/drpfleger/terraform/diagnostic-settings"
  target_resource_id           = "${azurerm_storage_account.main.id}/blobServices/default/"
  log_analytics_name           = var.log_analytics_name
  log_analytics_resource_group = var.log_analytics_resource_group
}
