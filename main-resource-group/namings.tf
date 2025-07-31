locals {
  key_vault_name       = "kvt-${var.project}-${var.environment}"
  network_watcher_name = "nw-${var.project}"
  admin_group_name     = "${var.project}-admin"
  budget_name          = "budget-monthly-${var.project}-${var.environment}"
  action_group_name    = "agrp-${var.project}"
  health_alert_name    = "health-alert-${var.project}-${var.environment}"
  # Action group short name with length validation and override option
  action_group_short_name = var.action_group_short_name_override != null ? var.action_group_short_name_override : (
    length(var.project) <= 12 ? var.project : substr(var.project, 0, 12)
  )
}
