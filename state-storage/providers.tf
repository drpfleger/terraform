terraform {
  required_providers {
    azurerm = {
      version = "~>4.12.0"
    }
  }
}

provider "azurerm" {
  features {
  }

  subscription_id = var.subscription_id
}

provider "azurerm" {
  alias = "log_analytics"
  features {}
  subscription_id = var.log_analytics_subscription == "" ? var.subscription_id : var.log_analytics_subscription
}
