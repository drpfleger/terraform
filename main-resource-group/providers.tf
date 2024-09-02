terraform {
  required_providers {
    azurerm = {
      version = "~>4.00.0"
    }
    azuread = {
      version = "~>2.53.0"
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

