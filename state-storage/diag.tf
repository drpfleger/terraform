## State Storage
module "monitoring_state_storage" {
  enabled                      = var.use_diagnostic_settings
  source                       = "github.com/drpfleger/terraform/diagnostic-settings?ref=diagnosticsettings"
  target_resource_id           = azurerm_storage_account.main.id
  log_analytics_name           = var.log_analytics_name
  log_analytics_subscription   = var.use_diagnostic_settings ? var.log_analytics_subscription : var.subscription_id
  log_analytics_resource_group = var.log_analytics_resource_group
}

# BlobService
module "monitoring_state_blob" {
  enabled                      = var.use_diagnostic_settings
  source                       = "github.com/drpfleger/terraform/diagnostic-settings?ref=diagnosticsettings"
  target_resource_id           = "${azurerm_storage_account.main.id}/blobServices/default/"
  log_analytics_name           = var.log_analytics_name
  log_analytics_subscription   = var.use_diagnostic_settings ? var.log_analytics_subscription : var.subscription_id
  log_analytics_resource_group = var.log_analytics_resource_group
}
