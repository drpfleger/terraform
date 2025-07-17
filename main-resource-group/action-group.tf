# Action Group for budget alerts
resource "azurerm_monitor_action_group" "main" {
  count               = var.enable_budget ? 1 : 0
  name                = local.action_group_name
  resource_group_name = data.azurerm_resource_group.main.name
  short_name          = local.action_group_short_name

  dynamic "email_receiver" {
    for_each = var.alert_email_receivers
    content {
      name          = "email-${email_receiver.key}"
      email_address = email_receiver.value
    }
  }

  tags = local.required_tags
}