resource "azurerm_consumption_budget_subscription" "main" {
  count           = var.create_subscription_budget ? 1 : 0
  name            = local.budget_monthly_name
  subscription_id = data.azurerm_subscription.current.id

  amount     = var.budget_amount
  time_grain = "Monthly"

  time_period {
    # A dynamic start date forces the replacement of the budget resource (⚡ DeleteLock),
    # but it cannot be a static date either, because the start date cannot be smaller than the current month.
    start_date = formatdate("YYYY-MM-01'T'00:00:00Z", timeadd(timestamp(), "24h"))
  }

  notification {
    enabled        = true
    threshold      = var.budget_forecast_threshold
    operator       = "EqualTo"
    threshold_type = "Forecasted"

    contact_groups = [
      azurerm_monitor_action_group.main.id
    ]
  }

  notification {
    enabled   = true
    threshold = var.budget_actual_threshold
    operator  = "GreaterThan"

    contact_groups = [
      azurerm_monitor_action_group.main.id
    ]

    contact_roles = [
      "Owner"
    ]
  }

  lifecycle {
    ignore_changes = [
      time_period
    ]
  }
}
