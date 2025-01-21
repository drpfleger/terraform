locals {
  app_name         = "${var.project}-${var.app_type}-${var.environment}"
  app_secret_name  = "${var.project}-${var.app_type}-secret"
  app_cert_name    = "${var.project}-${var.app_type}-cert"
  admin_group_name = "${var.project}-admin"
}
