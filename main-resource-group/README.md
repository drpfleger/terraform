# Main Resource Group Module

This Terraform module creates and manages a main resource group with associated resources including:
- Azure Key Vault
- Azure AD admin group
- Network Watcher
- Optional subscription budget monitoring
- Optional action group for budget alerts
- Optional resource health alerts

## Features

- **Resource Group Management**: Manages a central resource group for project resources
- **Key Vault**: Creates a key vault with configurable settings and RBAC
- **Admin Group**: Creates an Azure AD group with subscription-level permissions
- **Network Watcher**: Sets up network monitoring capabilities
- **Budget Monitoring**: Optional subscription-level budget with email notifications
- **Resource Health Alerts**: Optional monitoring of resource health status changes
- **Diagnostic Settings**: Optional integration with Log Analytics workspace

## Usage

### Basic Usage

```hcl
module "main_resource_group" {
  source = "github.com/drpfleger/terraform/main-resource-group"

  main_resource_group_name = "rg-myproject-dev"
  location                 = "westeurope"
  project                  = "myproject"
  environment              = "dev"
  subscription_id          = "12345678-1234-1234-1234-123456789012"
}
```

### With Budget Monitoring

```hcl
module "main_resource_group" {
  source = "github.com/drpfleger/terraform/main-resource-group"

  main_resource_group_name = "rg-myproject-dev"
  location                 = "westeurope"
  project                  = "myproject"
  environment              = "dev"
  subscription_id          = "12345678-1234-1234-1234-123456789012"

  # Budget configuration
  enable_budget              = true
  budget_amount              = 1000
  budget_forecast_threshold  = 80
  budget_actual_threshold    = 100
  alert_email_receivers      = ["admin@company.com", "finance@company.com"]
}
```

### With Diagnostic Settings

```hcl
module "main_resource_group" {
  source = "github.com/drpfleger/terraform/main-resource-group"

  main_resource_group_name = "rg-myproject-dev"
  location                 = "westeurope"
  project                  = "myproject"
  environment              = "dev"
  subscription_id          = "12345678-1234-1234-1234-123456789012"

  # Diagnostic settings
  use_diagnostic_settings      = true
  log_analytics_name           = "log-analytics-workspace"
  log_analytics_subscription   = "87654321-4321-4321-4321-210987654321"
  log_analytics_resource_group = "rg-monitoring"
}
```

### With Resource Health Alerts

```hcl
module "main_resource_group" {
  source = "github.com/drpfleger/terraform/main-resource-group"

  main_resource_group_name = "rg-myproject-dev"
  location                 = "westeurope"
  project                  = "myproject"
  environment              = "dev"
  subscription_id          = "12345678-1234-1234-1234-123456789012"

  # Resource health monitoring
  enable_resource_health_alert = true
  health_alert_email_receivers = ["admin@company.com", "ops@company.com"]
  health_alert_resource_types  = ["Microsoft.Compute/virtualMachines", "Microsoft.Storage/storageAccounts"]
}
```

### With Both Budget and Health Alerts

```hcl
module "main_resource_group" {
  source = "github.com/drpfleger/terraform/main-resource-group"

  main_resource_group_name = "rg-myproject-dev"
  location                 = "westeurope"
  project                  = "myproject"
  environment              = "dev"
  subscription_id          = "12345678-1234-1234-1234-123456789012"

  # Budget configuration
  enable_budget              = true
  budget_amount              = 1000
  budget_forecast_threshold  = 80
  budget_actual_threshold    = 100
  alert_email_receivers      = ["admin@company.com", "finance@company.com"]

  # Resource health monitoring (uses same action group as budget)
  enable_resource_health_alert = true
  health_alert_resource_types  = ["Microsoft.Compute/virtualMachines"]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 4.0 |
| azuread | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 4.0 |
| azuread | >= 3.0 |

## Resources

| Name | Type |
|------|------|
| azurerm_resource_group | data source |
| azurerm_subscription | data source |
| azurerm_key_vault | resource |
| azurerm_role_assignment | resource |
| azurerm_network_watcher | resource |
| azurerm_monitor_action_group | resource |
| azurerm_consumption_budget_subscription | resource |
| azuread_group | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| main_resource_group_name | Name of the central resource group | `string` | n/a | yes |
| project | The project name | `string` | n/a | yes |
| environment | Environment/Stage | `string` | n/a | yes |
| subscription_id | Subscription Id | `string` | n/a | yes |
| location | Azure resource location | `string` | `"westeurope"` | no |
| use_diagnostic_settings | True, when the diagnostic settings must be created | `bool` | `false` | no |
| keyvault_purge_protection | Enable or disable purge protection for the key vault | `bool` | `false` | no |
| keyvault_enabled_for_template_deployment | Enable or disable template deployment for the key vault | `bool` | `true` | no |
| keyvault_enabled_for_disk_encryption | Enable or disable disk encryption for the key vault | `bool` | `false` | no |
| keyvault_enabled_for_deployment | Enable or disable deployment for the key vault | `bool` | `true` | no |
| keyvault_enable_rbac_authorization | Enable or disable RBAC authorization for the key vault | `bool` | `true` | no |
| keyvault_public_network_access_enabled | Enable or disable public network access for the key vault | `bool` | `true` | no |
| keyvault_sku_name | The Name of the SKU used for this Key Vault | `string` | `"standard"` | no |
| log_analytics_name | Name of the log analytics workspace | `string` | `null` | no |
| log_analytics_subscription | Subscription id of the log analytics workspace | `string` | `null` | no |
| log_analytics_resource_group | Resource group of the log analytics workspace | `string` | `null` | no |
| group_assignable_to_role | True, when the EntraId group is assignable to a role | `bool` | `false` | no |
| admin_group_role | The role name that should be assigned to the created admin group on subscription level | `string` | `"Owner"` | no |
| override_keyvault_name | Override the key vault name | `string` | `null` | no |
| enable_budget | Enable budget monitoring for the subscription | `bool` | `false` | no |
| budget_amount | The budget amount in currency units. Required if enable_budget is true | `number` | `null` | no |
| budget_forecast_threshold | The budget forecast threshold percentage that triggers a notification | `number` | `80` | no |
| budget_actual_threshold | The budget actual threshold percentage that triggers a notification | `number` | `100` | no |
| alert_email_receivers | List of email addresses to receive budget alerts. Required if enable_budget is true | `list(string)` | `[]` | no |
| action_group_short_name_override | Override the action group short name (max 12 characters) | `string` | `null` | no |
| enable_resource_health_alert | Enable resource health monitoring and alerts | `bool` | `false` | no |
| health_alert_resource_types | List of resource types to monitor for health status | `list(string)` | `null` | no |
| health_alert_email_receivers | List of email addresses to receive health alerts | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| resource_group_id | ID of the main resource group |
| resource_group_name | Name of the main resource group |
| resource_group_location | Location of the main resource group |
| subscription_id | Current subscription ID |
| subscription_display_name | Current subscription display name |
| key_vault_id | ID of the main key vault |
| key_vault_name | Name of the main key vault |
| key_vault_uri | URI of the main key vault |
| admin_group_id | Object ID of the admin group |
| admin_group_name | Display name of the admin group |
| action_group_id | ID of the action group (if budget or health alerts are enabled) |
| action_group_name | Name of the action group (if budget or health alerts are enabled) |
| budget_id | ID of the subscription budget (if enabled) |
| budget_name | Name of the subscription budget (if enabled) |
| health_alert_id | ID of the resource health alert (if enabled) |
| health_alert_name | Name of the resource health alert (if enabled) |

## Naming Conventions

The module follows these naming conventions:

- Key Vault: `kvt-{project}-{environment}`
- Network Watcher: `nw-{project}`
- Admin Group: `{project}-admin`
- Budget: `budget-monthly-{project}-{environment}`
- Action Group: `agrp-{project}`
- Health Alert: `health-alert-{project}-{environment}`

## Budget and Alerting

When `enable_budget` is set to `true`, the module creates:

1. **Azure Monitor Action Group**: Configured with email receivers for alert notifications
2. **Subscription Budget**: Monthly budget with configurable thresholds for both forecasted and actual spending

### Budget Thresholds

- **Forecast Threshold**: Triggers alert when forecasted spending reaches the percentage (default: 80%)
- **Actual Threshold**: Triggers alert when actual spending reaches the percentage (default: 100%)

### Email Validation

The module validates that:
- At least one email address is provided when budget is enabled
- All email addresses follow a valid email format

## Resource Health Monitoring

When `enable_resource_health_alert` is set to `true`, the module creates:

1. **Azure Monitor Action Group**: Shared with budget alerts or created specifically for health alerts
2. **Activity Log Alert**: Monitors resource health status changes from "Available" to "Degraded" or "Unavailable"

### Health Alert Configuration

- **Resource Types**: Optional list of specific resource types to monitor (if not provided, monitors all resources in the resource group)
- **Health States**: Monitors transitions from "Available" to "Degraded" or "Unavailable"
- **Scope**: Subscription-level monitoring filtered by the resource group

### Email Configuration

When health alerts are enabled:
- If budget alerts are also enabled, health alerts use the budget email receivers
- If budget alerts are not enabled, you must provide `health_alert_email_receivers`
- The module ensures at least one notification method is configured

### Shared Action Group

The action group is intelligently shared between budget and health alerts:
- If only budget is enabled: Action group receives budget notifications
- If only health alerts are enabled: Action group receives health notifications  
- If both are enabled: Action group receives both types of notifications

## License

This module is maintained by the infrastructure team.