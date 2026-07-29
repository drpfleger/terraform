locals {
  alert_rule_name                = "ar-${var.project}-${var.environment}"
  service_health_alert_rule_name = "ar-${var.project}-${var.environment}-sh"
}
