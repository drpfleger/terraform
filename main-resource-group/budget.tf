# Action Group for budget alerts
resource "azurerm_monitor_action_group" "budget_alerts" {
  count               = var.enable_budget ? 1 : 0
  name                = local.action_group_name
  resource_group_name = data.azurerm_resource_group.main.name
  short_name          = "budget"

  dynamic "email_receiver" {
    for_each = var.alert_email_receivers
    content {
      name          = "email-${email_receiver.key}"
      email_address = email_receiver.value
    }
  }

  tags = local.required_tags
}

# Subscription Budget
resource "azurerm_consumption_budget_subscription" "main" {
  count           = var.enable_budget ? 1 : 0
  name            = local.budget_name
  subscription_id = data.azurerm_subscription.main.subscription_id

  amount     = var.budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00'Z'", timestamp())
  }

  notification {
    enabled   = true
    threshold = var.budget_forecast_threshold
    operator  = "GreaterThan"

    contact_groups = [
      azurerm_monitor_action_group.budget_alerts[0].id
    ]

    threshold_type = "Forecasted"
  }

  notification {
    enabled   = true
    threshold = var.budget_actual_threshold
    operator  = "GreaterThan"

    contact_groups = [
      azurerm_monitor_action_group.budget_alerts[0].id
    ]

    threshold_type = "Actual"
  }
}