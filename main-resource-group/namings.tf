locals {
  action_group_name       = "agrp-${var.project}"
  action_group_short_name = upper("${substr(var.project, 0, min(length(var.project), 7))}-${var.environment}")
  admin_group_name        = "${var.project}-admin"
  budget_monthly_name     = "budget-monthly-${data.azurerm_subscription.current.display_name}"
  key_vault_name          = "kvt-${var.project}-${var.environment}"
  network_watcher_name    = "nw-${var.project}"
}
