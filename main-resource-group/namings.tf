locals {
  admin_group_name     = "${var.project}-admin"
  budget_monthly_name  = "budget-monthly-${data.azurerm_subscription.current.display_name}"
  key_vault_name       = "kvt-${var.project}-${var.environment}"
  network_watcher_name = "nw-${var.project}"
}
