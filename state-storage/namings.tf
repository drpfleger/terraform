locals {
  storage_account_name = "sto${var.project}state${var.environment}"
  container_name       = "tfstate"
}
