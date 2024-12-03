terraform {
  required_providers {
    azurerm = {
      version = ">=4.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

provider "azurerm" {
  alias           = "log_analytics"
  subscription_id = var.log_analytics_subscription == "" ? var.subscription_id : var.log_analytics_subscription
  features {}
}
