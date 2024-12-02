terraform {
  required_providers {
    azurerm = {
      version = "~>4.12.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
