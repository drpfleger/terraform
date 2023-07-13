# Monitoring Key Vault
module "monitoring_key_vault" {
  enabled                      = var.use_diagnostic_settings
  source                       = "github.com/drpfleger/terraform/diagnostic-settings"
  target_resource_id           = azurerm_key_vault.main.id
  log_analytics_name           = var.log_analytics_name
  log_analytics_subscription   = var.log_analytics_subscription
  log_analytics_resource_group = var.log_analytics_resource_group
}
