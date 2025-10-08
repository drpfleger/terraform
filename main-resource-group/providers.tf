terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      version = ">=4.43.0"
    }
    azuread = {
      version = ">=3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7"
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
  subscription_id = var.log_analytics_subscription == null ? var.subscription_id : var.log_analytics_subscription
  features {}
}
