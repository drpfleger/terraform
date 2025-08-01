terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.31.0"
      configuration_aliases = [
        azurerm.log_analytics,
        azurerm.target
      ]
    }
  }
}
