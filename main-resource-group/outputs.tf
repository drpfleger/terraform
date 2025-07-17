# Resource Group outputs
output "resource_group_id" {
  description = "ID of the main resource group"
  value       = data.azurerm_resource_group.main.id
}

output "resource_group_name" {
  description = "Name of the main resource group"
  value       = data.azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the main resource group"
  value       = data.azurerm_resource_group.main.location
}

# Subscription outputs
output "subscription_id" {
  description = "Current subscription ID"
  value       = data.azurerm_subscription.main.subscription_id
}

output "subscription_display_name" {
  description = "Current subscription display name"
  value       = data.azurerm_subscription.main.display_name
}

# Key Vault outputs
output "key_vault_id" {
  description = "ID of the main key vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Name of the main key vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the main key vault"
  value       = azurerm_key_vault.main.vault_uri
}

# Admin Group outputs
output "admin_group_id" {
  description = "Object ID of the admin group"
  value       = azuread_group.admin_group.object_id
}

output "admin_group_name" {
  description = "Display name of the admin group"
  value       = azuread_group.admin_group.display_name
}

# Budget and Action Group outputs (conditional)
output "action_group_id" {
  description = "ID of the budget action group (if enabled)"
  value       = var.enable_budget ? azurerm_monitor_action_group.main[0].id : null
}

output "action_group_name" {
  description = "Name of the budget action group (if enabled)"
  value       = var.enable_budget ? azurerm_monitor_action_group.main[0].name : null
}

output "budget_id" {
  description = "ID of the subscription budget (if enabled)"
  value       = var.enable_budget ? azurerm_consumption_budget_subscription.main[0].id : null
}

output "budget_name" {
  description = "Name of the subscription budget (if enabled)"
  value       = var.enable_budget ? azurerm_consumption_budget_subscription.main[0].name : null
}