# Purpose: Set Azure RBAC assignments for this service principal
# Usage: Define the RBAC Scope and Role Definition Name for each assignment via the rbac_assignments variable.
resource "azurerm_role_assignment" "main" {
  for_each = var.rbac_assignments

  scope                = each.value.scope_id
  role_definition_name = each.value.role_definition_name
  principal_id         = azuread_service_principal.main.id
}
