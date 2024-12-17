resource "azurerm_monitor_action_group" "main" {
  count               = var.create_action_group ? 1 : 0
  name                = local.action_group_name
  resource_group_name = data.azurerm_resource_group.main.name
  short_name          = local.action_group_short_name

  dynamic "email_receiver" {
    for_each = var.budget_email_addresses == null ? [] : var.budget_email_addresses
    content {
      name          = email_receiver.value
      email_address = email_receiver.value
    }
  }

  tags = local.required_tags
}
