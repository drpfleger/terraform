# Sample Usage of the Diagnostic Settings Module

```hcl
provider "azurerm" {
    features {
        key_vault {
            purge_soft_delete_on_destroy = true
        }
    }
    subscription_id = "00000000-0000-0000-0000-000000000000"
}
```

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

### Create Diagnostic Settings with _ALL_ Categories and Metrics for Storage Account

```hcl
module "diag_storage" {
    source = "../diagnostic-settings"

    target_resource_id = azurerm_storage_account.smpl.id
    enabled            = true

    log_analytics_name           = local.log_analytics_name
    log_analytics_subscription   = local.log_analytics_subscription
    log_analytics_resource_group = local.log_analytics_resource_group

}
```

### Create Diagnostic Settings with user defined Category Groups and user defined Metrics for Blob Service

```hcl
module "diag_container_blob" {
source = "../diagnostic-settings"
enabled = true
target_resource_id = "${azurerm_storage_account.smpl.id}/blobServices/default/"

    log_analytics_name           = local.log_analytics_name
    log_analytics_subscription   = local.log_analytics_subscription
    log_analytics_resource_group = local.log_analytics_resource_group

    user_defined_category_groups = ["audit"]
    user_defined_metrics         = ["Capacity"]

}
```

### Create Diagnostic Settings with user defined Categories and all Metrics for Queue Service

```hcl
module "diag_container_queue" {
source = "../diagnostic-settings"
enabled = true
target_resource_id = "${azurerm_storage_account.smpl.id}/queueServices/default/"

    log_analytics_name           = local.log_analytics_name
    log_analytics_subscription   = local.log_analytics_subscription
    log_analytics_resource_group = local.log_analytics_resource_group

    user_defined_categories = ["StorageDelete"]

}
```
