# access different subscription to get log analytics workspace
provider "azurerm" {
  alias = "monitoring_subscription"
  features {}
  subscription_id = var.log_analytics_subscription
}
