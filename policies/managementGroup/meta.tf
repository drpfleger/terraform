data "azurerm_management_group" "definition" {
  name = var.definition_management_group
}

data "azurerm_management_group" "assignment" {
  for_each = toset(var.assignment_management_groups)
  name     = each.value
}
