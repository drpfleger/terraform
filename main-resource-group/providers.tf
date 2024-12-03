terraform {
  required_providers {
    azurerm = {
      version = ">=4.0"
    }
    azuread = {
      version = ">=3.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

  subscription_id = var.subscription_id
}

provider "azurerm" {
  alias           = "log_analytics"
  subscription_id = var.log_analytics_subscription == "" ? var.subscription_id : var.log_analytics_subscription
  features {}
}
