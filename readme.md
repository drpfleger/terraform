# Sample Usage of the Diagnostic Settings Module

### General Information

In Terraform, providers are responsible for managing the lifecycle of resources. When using modules,
you can pass providers explicitly to ensure that the module uses the correct provider configurations.

For more information, refer to the Terraform [documentation](https://developer.hashicorp.com/terraform/language/modules/develop/providers#passing-providers-explicitly).

The `azurerm` provider is configured with the subscription ID where the target resources will be created. An aliased `azurerm` provider, named `log_analytics`, is configured with the subscription ID where the Log Analytics Workspace resides. These providers are then injected into the monitoring module to ensure the resources are created and managed in the correct subscriptions.

---

### Define Log Analytics Workspace

```hcl
locals {
    log_analytics_name           = "log-mgmt-prd"
    log_analytics_subscription   = "00000000-0000-0000-0000-000000000000"
    log_analytics_resource_group = "rg-mgmt-prd"
}
```

### Create Resource Group and Storage Account

```hcl
resource "azurerm_resource_group" "smpl" {
    name     = "rg-smpl-prd"
    location = "westeurope"
}

resource "azurerm_storage_account" "smpl" {
    name                     = "stosmplprd"
    resource_group_name      = azurerm_resource_group.smpl.name
    location                 = azurerm_resource_group.smpl.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}
```

### Define providers for your module and the Log Analytics Workspace

```hcl
provider "azurerm" {
  subscription_id = "00000000-0000-0000-0000-000000000000"
  features {}
}

provider "azurerm" {
  alias = "log_analytics"
  subscription_id =     "00000000-0000-0000-0000-000000000000"
  features {}
}

```

### Create Diagnostic Settings with _ALL_ Categories and Metrics for Storage Account

```hcl
module "diag_storage" {
    source = "../diagnostic-settings"

    providers = {
        azurerm.target        = azurerm,
        azurerm.log_analytics = azurerm.log_analytics
    }

    target_resource_id           = azurerm_storage_account.smpl.id
    log_analytics_name           = local.log_analytics_name
    log_analytics_resource_group = local.log_analytics_resource_group

}
```

### Create Diagnostic Settings with user defined Category Groups and user defined Metrics for Blob Service

```hcl
module "diag_container_blob" {
    source = "../diagnostic-settings"

    providers = {
        azurerm.target        = azurerm,
        azurerm.log_analytics = azurerm.log_analytics
    }

    target_resource_id = "${azurerm_storage_account.smpl.id}/blobServices/default/"
    log_analytics_name           = local.log_analytics_name
    log_analytics_resource_group = local.log_analytics_resource_group

    user_defined_category_groups = ["audit"]
    user_defined_metrics         = ["Capacity"]

}
```

### Create Diagnostic Settings with user defined Categories and all Metrics for Queue Service

```hcl
module "diag_container_queue" {
    source = "../diagnostic-settings"

    providers = {
        azurerm.target        = azurerm,
        azurerm.log_analytics = azurerm.log_analytics
    }

    target_resource_id = "${azurerm_storage_account.smpl.id}/queueServices/default/"
    log_analytics_name           = local.log_analytics_name
    log_analytics_subscription   = local.log_analytics_subscription
    log_analytics_resource_group = local.log_analytics_resource_group

    user_defined_categories = ["StorageDelete"]

}
```
