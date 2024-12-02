locals {
  alert_rule_name     = "ar-${var.project}-${var.environment}"
  resource_group_name = "rg-${var.project}-${var.environment}"
}
