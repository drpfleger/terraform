locals {
  key_vault_name       = "kvt-${var.project}-${var.environment}"
  network_watcher_name = "nw-${var.project}"
  admin_group_name     = "${var.project}-admin"
  budget_name          = "budget-monthly-${var.project}-${var.environment}"
  action_group_name    = "agrp-${var.project}"
}
