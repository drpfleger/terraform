terraform {
  required_providers {
    azurerm = {
      version = ">=4.31.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

provider "azurerm" {
  alias           = "log_analytics"
  subscription_id = var.log_analytics_subscription == null ? var.subscription_id : var.log_analytics_subscription
  features {}
}
