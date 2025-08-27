# Subscription Budget
resource "azurerm_consumption_budget_subscription" "main" {
  count           = var.enable_budget ? 1 : 0
  name            = local.budget_name
  subscription_id = data.azurerm_subscription.main.id

  amount     = var.budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00'Z'", timeadd(timestamp(), "24h"))
  }

  notification {
    enabled   = true
    threshold = var.budget_forecast_threshold
    operator  = "GreaterThan"

    contact_groups = [
      azurerm_monitor_action_group.main.id
    ]

    threshold_type = "Forecasted"
  }

  notification {
    enabled   = true
    threshold = var.budget_actual_threshold
    operator  = "GreaterThan"

    contact_groups = [
      azurerm_monitor_action_group.main.id
    ]

    threshold_type = "Actual"
  }
}