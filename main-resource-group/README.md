# Main Resource Group Module

This module manages baseline resources in a central Azure resource group and provides optional integrations for diagnostics, budget alerting, and health monitoring.

## Features

- Key Vault provisioning with configurable security settings.
- Entra admin group creation and subscription RBAC assignment.
- Network Watcher provisioning.
- Optional diagnostic settings integration with Log Analytics.
- Optional subscription budget and Action Group notification wiring.
- Optional ResourceHealth and ServiceHealth alert integration.

## Usage

### Basic Usage (Core Resources)

```hcl
module "main_resource_group" {
  source = "github.com/drpfleger/terraform/main-resource-group"

  main_resource_group_name    = "rg-myproject-dev"
  location                    = "westeurope"
  project                     = "myproject"
  environment                 = "dev"
  subscription_id             = "12345678-1234-1234-1234-123456789012"

  # Disable optional monitoring defaults for a minimal setup
  enable_resource_health_alert = false
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

  enable_budget         = true
  budget_amount         = 1000
  alert_email_receivers = ["admin@company.com", "finance@company.com"]
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

  use_diagnostic_settings      = true
  log_analytics_name           = "law-platform-dev"
  log_analytics_subscription   = "12345678-1234-1234-1234-123456789012"
  log_analytics_resource_group = "rg-monitoring-dev"
}
```

### With Health Alert Integration

```hcl
module "main_resource_group" {
  source = "github.com/drpfleger/terraform/main-resource-group"

  main_resource_group_name     = "rg-myproject-dev"
  location                     = "westeurope"
  project                      = "myproject"
  environment                  = "dev"
  subscription_id              = "12345678-1234-1234-1234-123456789012"
  health_alert_email_receivers = ["ops@company.com"]

  enable_resource_health_alert  = true
  enable_service_health_alert   = true
  health_alert_scope_mode       = "subscription"
  health_alert_service_events   = ["Incident", "Maintenance", "ActionRequired", "Security"]
  health_alert_service_locations = ["westeurope", "global"]
}
```

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.0    |
| azurerm   | >= 4.43.0 |
| azuread   | >= 3.0    |
| time      | >= 0.7    |

## Providers

| Name    | Alias         | Notes                                                         |
| ------- | ------------- | ------------------------------------------------------------- |
| azurerm | default       | Deploys resources in `subscription_id`                        |
| azurerm | log_analytics | Used when diagnostic settings target a different subscription |
| azuread | n/a           | Entra group management                                        |
| time    | n/a           | Budget start date anchoring                                   |

## Inputs

### Core

| Name                     | Description                                            | Type     | Default        | Required |
| ------------------------ | ------------------------------------------------------ | -------- | -------------- | -------- |
| main_resource_group_name | Name of the central resource group                     | `string` | n/a            | yes      |
| location                 | Azure resource location                                | `string` | `"westeurope"` | no       |
| project                  | Project name                                           | `string` | n/a            | yes      |
| environment              | Environment/stage (`dev`, `sbx`, `tst`, `main`, `prd`) | `string` | n/a            | yes      |
| subscription_id          | Subscription ID                                        | `string` | n/a            | yes      |
| group_assignable_to_role | Whether the admin Entra group is role assignable       | `bool`   | `false`        | no       |
| admin_group_role         | Role assigned to the admin group at subscription scope | `string` | `"Owner"`      | no       |
| override_keyvault_name   | Optional override for Key Vault name                   | `string` | `null`         | no       |

### Key Vault

| Name                                     | Description                             | Type     | Default      | Required |
| ---------------------------------------- | --------------------------------------- | -------- | ------------ | -------- |
| keyvault_purge_protection                | Enable purge protection                 | `bool`   | `false`      | no       |
| keyvault_enabled_for_template_deployment | Enable template deployment support      | `bool`   | `true`       | no       |
| keyvault_enabled_for_disk_encryption     | Enable disk encryption support          | `bool`   | `false`      | no       |
| keyvault_enabled_for_deployment          | Enable deployment support               | `bool`   | `true`       | no       |
| keyvault_enable_rbac_authorization       | Enable RBAC authorization               | `bool`   | `true`       | no       |
| keyvault_public_network_access_enabled   | Enable public network access            | `bool`   | `true`       | no       |
| keyvault_sku_name                        | Key Vault SKU (`standard` or `premium`) | `string` | `"standard"` | no       |

### Diagnostics

| Name                         | Description                            | Type     | Default | Required |
| ---------------------------- | -------------------------------------- | -------- | ------- | -------- |
| use_diagnostic_settings      | Create diagnostic settings integration | `bool`   | `false` | no       |
| log_analytics_name           | Log Analytics workspace name           | `string` | `null`  | no       |
| log_analytics_subscription   | Log Analytics subscription ID          | `string` | `null`  | no       |
| log_analytics_resource_group | Log Analytics resource group           | `string` | `null`  | no       |

### Budget and Action Group

| Name                             | Description                                              | Type           | Default | Required |
| -------------------------------- | -------------------------------------------------------- | -------------- | ------- | -------- |
| enable_budget                    | Enable subscription budget monitoring                    | `bool`         | `false` | no       |
| budget_amount                    | Budget amount (required when budget is enabled)          | `number`       | `null`  | no       |
| budget_forecast_threshold        | Forecast threshold percentage                            | `number`       | `80`    | no       |
| budget_actual_threshold          | Actual threshold percentage                              | `number`       | `100`   | no       |
| alert_email_receivers            | Email receivers for budget alerts                        | `list(string)` | `[]`    | no       |
| action_group_short_name_override | Optional action group short name override (max 12 chars) | `string`       | `null`  | no       |

### Health Alert Integration

| Name                           | Description                                                                      | Type           | Default                                                     | Required |
| ------------------------------ | -------------------------------------------------------------------------------- | -------------- | ----------------------------------------------------------- | -------- |
| enable_resource_health_alert   | Enable ResourceHealth integration                                                | `bool`         | `true`                                                      | no       |
| enable_service_health_alert    | Enable ServiceHealth integration                                                 | `bool`         | `false`                                                     | no       |
| health_alert_scope_mode        | ResourceHealth filter mode (`subscription`, `resource_group`, `resource_groups`) | `string`       | `"subscription"`                                            | no       |
| health_alert_resource_groups   | Resource group list used when scope mode is `resource_groups`                    | `list(string)` | `null`                                                      | no       |
| health_alert_resource_types    | Optional ResourceHealth resource type filter                                     | `list(string)` | `null`                                                      | no       |
| health_alert_service_events    | ServiceHealth event filter                                                       | `list(string)` | `["Incident", "Maintenance", "ActionRequired", "Security"]` | no       |
| health_alert_service_services  | Optional ServiceHealth services filter                                           | `list(string)` | `null`                                                      | no       |
| health_alert_service_locations | Optional ServiceHealth locations filter                                          | `list(string)` | `null`                                                      | no       |
| health_alert_email_receivers   | Optional health alert email receivers                                            | `list(string)` | `[]`                                                        | no       |

## Outputs

| Name                      | Description                                                           |
| ------------------------- | --------------------------------------------------------------------- |
| resource_group_id         | ID of the main resource group                                         |
| resource_group_name       | Name of the main resource group                                       |
| resource_group_location   | Location of the main resource group                                   |
| subscription_id           | Current subscription ID                                               |
| subscription_display_name | Current subscription display name                                     |
| key_vault_id              | ID of the main key vault                                              |
| key_vault_name            | Name of the main key vault                                            |
| key_vault_uri             | URI of the main key vault                                             |
| admin_group_id            | Object ID of the admin group                                          |
| admin_group_name          | Display name of the admin group                                       |
| action_group_id           | ID of the action group (if budget or health integration is enabled)   |
| action_group_name         | Name of the action group (if budget or health integration is enabled) |
| budget_id                 | ID of the budget (if enabled)                                         |
| budget_name               | Name of the budget (if enabled)                                       |
| health_alert_id           | ID of the ResourceHealth alert (if enabled)                           |
| health_alert_name         | Name of the ResourceHealth alert (if enabled)                         |
| service_health_alert_id   | ID of the ServiceHealth alert (if enabled)                            |
| service_health_alert_name | Name of the ServiceHealth alert (if enabled)                          |

## Notes

- Health monitoring is implemented through the dedicated `resource-health-alert` module.
- ResourceHealth default behavior is subscription-wide for the same `subscription_id` used by this module.

## License

This module is maintained by the infrastructure team.
