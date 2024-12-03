# Monitoring Key Vault
module "monitoring_key_vault" {
  count = var.use_diagnostic_settings ? 1 : 0
  providers = {
    azurerm.target        = azurerm,
    azurerm.log_analytics = azurerm.log_analytics
  }

  source = "github.com/drpfleger/terraform/diagnostic-settings?ref=statestorage"

  target_resource_id           = azurerm_key_vault.main.id
  log_analytics_name           = var.log_analytics_name
  log_analytics_resource_group = var.log_analytics_resource_group
}
