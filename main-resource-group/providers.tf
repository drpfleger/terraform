terraform {
  required_providers {
    azurerm = {
      version = "~>3.64.0"
    }
    azuread = {
      version = ">=2.37.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

