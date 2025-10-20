# Diagnostic Settings Module

This Terraform module creates Azure Monitor diagnostic settings for Azure resources, enabling log and metric collection to a Log Analytics workspace. It supports both category groups and individual categories, with automatic detection of available diagnostic categories for the target resource.

## Features

- **Flexible Log Collection**: Supports both category groups and individual log categories
- **Metric Monitoring**: Collects resource metrics for monitoring and analysis
- **Cross-Subscription Support**: Can send diagnostics to Log Analytics workspace in different subscriptions
- **Automatic Category Detection**: Automatically discovers available log categories and metrics for the target resource
- **Configurable Destination**: Supports AzureDiagnostics and Dedicated table destinations

## Usage

### Basic Usage - All Categories and Metrics

```hcl
module "diagnostic_settings" {
  source = "github.com/drpfleger/terraform/diagnostic-settings"

  providers = {
    azurerm.target        = azurerm
    azurerm.log_analytics = azurerm.log_analytics
  }

  target_resource_id           = azurerm_storage_account.example.id
  log_analytics_name           = "log-analytics-workspace"
  log_analytics_resource_group = "rg-monitoring"
}
```

### With Custom Category Groups

```hcl
module "diagnostic_settings" {
  source = "github.com/drpfleger/terraform/diagnostic-settings"

  providers = {
    azurerm.target        = azurerm
    azurerm.log_analytics = azurerm.log_analytics
  }

  target_resource_id           = azurerm_storage_account.example.id
  log_analytics_name           = "log-analytics-workspace"
  log_analytics_resource_group = "rg-monitoring"

  user_defined_category_groups = ["audit", "allLogs"]
  user_defined_metrics         = ["Capacity", "Transaction"]
}
```

### With Individual Categories

```hcl
module "diagnostic_settings" {
  source = "github.com/drpfleger/terraform/diagnostic-settings"

  providers = {
    azurerm.target        = azurerm
    azurerm.log_analytics = azurerm.log_analytics
  }

  target_resource_id           = azurerm_storage_account.example.id
  log_analytics_name           = "log-analytics-workspace"
  log_analytics_resource_group = "rg-monitoring"

  user_defined_categories = ["StorageWrite", "StorageDelete"]
  user_defined_metrics    = ["Transaction"]
}
```

### Cross-Subscription Example

```hcl
# Provider for target resource
provider "azurerm" {
  subscription_id = "target-subscription-id"
  features {}
}

# Provider for Log Analytics workspace
provider "azurerm" {
  alias           = "log_analytics"
  subscription_id = "monitoring-subscription-id"
  features {}
}

module "diagnostic_settings" {
  source = "github.com/drpfleger/terraform/diagnostic-settings"

  providers = {
    azurerm.target        = azurerm
    azurerm.log_analytics = azurerm.log_analytics
  }

  target_resource_id           = azurerm_storage_account.example.id
  log_analytics_name           = "log-analytics-workspace"
  log_analytics_resource_group = "rg-monitoring"

  destination_type = "Dedicated"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 4.31.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm.target | >= 4.31.0 |
| azurerm.log_analytics | >= 4.31.0 |

## Resources

| Name | Type |
|------|------|
| azurerm_monitor_diagnostic_setting | resource |
| azurerm_monitor_diagnostic_categories | data source |
| azurerm_log_analytics_workspace | data source |
| azurerm_resource_group | data source |
| azurerm_subscription | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| target_resource_id | ID of the resource to implement diagnostic settings | `string` | n/a | yes |
| log_analytics_name | Name of the log analytics workspace | `string` | n/a | yes |
| log_analytics_resource_group | Resource group of the log analytics workspace | `string` | n/a | yes |
| enabled | Value to enable or disable the diagnostic settings | `bool` | `true` | no |
| diagnostic_name | Name of the diagnostic settings | `string` | `"diag-default"` | no |
| destination_type | Log destination type. Must be AzureDiagnostics, Dedicated, or Skip | `string` | `"Skip"` | no |
| user_defined_category_groups | List of user defined category groups to be sent to log analytics | `list(string)` | `null` | no |
| user_defined_categories | List of user defined categories to be sent to log analytics | `list(string)` | `null` | no |
| user_defined_metrics | List of user defined metrics to be sent to log analytics | `list(string)` | `null` | no |

## Outputs

This module does not expose any outputs.

## Provider Configuration

This module requires two provider configurations:

1. **azurerm.target**: Provider for the subscription containing the target resource
2. **azurerm.log_analytics**: Provider for the subscription containing the Log Analytics workspace

## Important Notes

- **Mutually Exclusive Categories**: You can use either `user_defined_category_groups` OR `user_defined_categories`, but not both
- **Automatic Detection**: If no user-defined categories or metrics are specified, the module automatically collects all available categories and metrics for the resource
- **Cross-Subscription Support**: The module supports scenarios where the target resource and Log Analytics workspace are in different subscriptions
- **Destination Types**:
  - `AzureDiagnostics`: Logs go to the AzureDiagnostics table
  - `Dedicated`: Logs go to resource-specific tables
  - `Skip`: No destination type is set (useful for certain scenarios)

## Examples of Resource Types

This module works with any Azure resource that supports diagnostic settings, including:

- Storage Accounts (`Microsoft.Storage/storageAccounts`)
- Storage Account Services (Blob, Queue, Table, File)
- Virtual Machines (`Microsoft.Compute/virtualMachines`)
- Key Vaults (`Microsoft.KeyVault/vaults`)
- Application Gateways (`Microsoft.Network/applicationGateways`)
- Network Security Groups (`Microsoft.Network/networkSecurityGroups`)

## License

This module is maintained by the infrastructure team.