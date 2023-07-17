locals {
  key_vault_name       = "kvt-${var.project}-${var.environment}"
  network_watcher_name = "nw-${var.project}"
  admin_group_name     = var.admin_group_name == "" ? "${var.project}-admin" : var.admin_group_name
}
