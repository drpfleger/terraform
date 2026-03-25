resource "azurerm_policy_definition" "main" {
  name                = var.policy_name
  display_name        = var.policy_display_name
  mode                = var.policy_mode
  policy_type         = "Custom"
  management_group_id = data.azurerm_management_group.definition.id
  policy_rule         = jsonencode(var.policy_rule)
  metadata            = jsonencode(var.meta_data)
}

resource "azurerm_management_group_policy_assignment" "main" {
  for_each = data.azurerm_management_group.assignment

  name                 = var.assignment_name
  policy_definition_id = azurerm_policy_definition.main.id
  management_group_id  = each.value.id
}
