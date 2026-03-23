resource "azurerm_policy_definition" "main" {
  name                = var.policy_name
  display_name        = var.policy_display_name
  mode                = var.policy_mode
  policy_type         = "Custom"
  management_group_id = data.azurerm_management_group.main.id
  policy_rule         = jsonencode(var.policy_rule)
}

resource "azurerm_management_group_policy_assignment" "example" {
  name                 = var.assignment_name
  policy_definition_id = azurerm_policy_definition.main.id
  management_group_id  = data.azurerm_management_group.main.id
}
