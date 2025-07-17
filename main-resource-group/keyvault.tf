# Azure Key Vault soft delete is a feature that allows to recover deleted vault or vault items,
# it stays available for a period of 90 days and it is useful for scenarios where a user may
# accidentally delete a critical item, like a key for production encryption.
#
# In February 2025, Microsoft will enable soft-delete protection on all key vaults, and users will no
# longer be able to opt out of or turn off soft-delete.
#
# For Development it's may be useful to purge key vault after you deleted it
# `az keyvault purge --name kvt-zombie-tst`

# Key vault
resource "azurerm_key_vault" "main" {
  name                            = var.override_keyvault_name != null ? var.override_keyvault_name : local.key_vault_name
  location                        = var.location
  resource_group_name             = data.azurerm_resource_group.main.name
  tenant_id                       = data.azurerm_subscription.main.tenant_id
  enabled_for_template_deployment = var.keyvault_enabled_for_template_deployment
  enabled_for_disk_encryption     = var.keyvault_enabled_for_disk_encryption
  enabled_for_deployment          = var.keyvault_enabled_for_deployment
  enable_rbac_authorization       = var.keyvault_enable_rbac_authorization
  public_network_access_enabled   = var.keyvault_public_network_access_enabled
  purge_protection_enabled        = var.keyvault_purge_protection
  sku_name                        = var.keyvault_sku_name

  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = local.required_tags
}

resource "azurerm_role_assignment" "keyvault_admin" {
  count                = var.keyvault_enable_rbac_authorization ? 1 : 0
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azuread_group.admin_group.object_id
}
