# Resource Health Alert Module

This Terraform module creates Azure Monitor activity log alerts for resource health status monitoring. It monitors resource health status changes from "Available" to "Degraded" or "Unavailable" and triggers notifications through an Azure Monitor Action Group.

## Features

- **Resource Health Monitoring**: Monitors health status changes of Azure resources
- **Subscription-Level Scope**: Monitors resources across the entire subscription, filtered by resource group
- **Flexible Resource Types**: Can monitor all resource types or specific types only
- **Action Group Integration**: Integrates with existing Azure Monitor Action Groups for notifications
- **Configurable Alerting**: Can be enabled or disabled as needed

## Usage

### Basic Usage - All Resource Types

```hcl
module "resource_health_alert" {
  source = "github.com/drpfleger/terraform/resource-health-alert"

  subscription_id       = "12345678-1234-1234-1234-123456789012"
  project              = "myproject"
  environment          = "dev"
  resource_group_name  = "rg-myproject-dev"
  action_group_id      = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-alerts"
}
```

### Monitor Specific Resource Types

```hcl
module "resource_health_alert" {
  source = "github.com/drpfleger/terraform/resource-health-alert"

  subscription_id       = "12345678-1234-1234-1234-123456789012"
  project              = "myproject"
  environment          = "dev"
  resource_group_name  = "rg-myproject-dev"
  action_group_id      = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-alerts"

  resource_types = [
    "Microsoft.Compute/virtualMachines",
    "Microsoft.Storage/storageAccounts",
    "Microsoft.KeyVault/vaults"
  ]
}
```

### Disabled Alert (For Testing)

```hcl
module "resource_health_alert" {
  source = "github.com/drpfleger/terraform/resource-health-alert"

  subscription_id       = "12345678-1234-1234-1234-123456789012"
  project              = "myproject"
  environment          = "dev"
  resource_group_name  = "rg-myproject-dev"
  action_group_id      = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-alerts"

  enable_health_alert = false
}
```

### Integration with Main Resource Group Module

This module is commonly used together with the main-resource-group module:

```hcl
module "main_resource_group" {
  source = "github.com/drpfleger/terraform/main-resource-group"

  main_resource_group_name = "rg-myproject-dev"
  location                 = "westeurope"
  project                  = "myproject"
  environment              = "dev"
  subscription_id          = "12345678-1234-1234-1234-123456789012"

  # Enable budget to create action group
  enable_budget         = true
  budget_amount         = 1000
  alert_email_receivers = ["admin@company.com"]
}

module "resource_health_alert" {
  source = "github.com/drpfleger/terraform/resource-health-alert"

  subscription_id      = "12345678-1234-1234-1234-123456789012"
  project             = "myproject"
  environment         = "dev"
  resource_group_name = module.main_resource_group.resource_group_name
  action_group_id     = module.main_resource_group.action_group_id

  resource_types = [
    "Microsoft.Compute/virtualMachines",
    "Microsoft.Storage/storageAccounts"
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 4.0 |

## Resources

| Name | Type |
|------|------|
| azurerm_monitor_activity_log_alert | resource |
| azurerm_resource_group | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| subscription_id | The Azure Subscription ID where the resources will be deployed | `string` | n/a | yes |
| project | The name of the project for which the resources are being created | `string` | n/a | yes |
| environment | The deployment environment or stage (e.g., dev, sbx, tst, prd) | `string` | n/a | yes |
| resource_group_name | The name of the resource group where the resources will be deployed | `string` | n/a | yes |
| action_group_id | The ID of the Action Group to be used for alert notifications | `string` | n/a | yes |
| resource_types | A list of resource types that need to be monitored for health status | `list(string)` | `null` | no |
| enable_health_alert | A boolean flag to enable or disable health alerts for the monitored resources | `bool` | `true` | no |

## Outputs

This module does not expose any outputs.

## Naming Conventions

The module follows these naming conventions:

- **Alert Rule**: `ar-{project}-{environment}`

## Resource Health Status Monitoring

The module monitors the following health status transitions:

| Previous Status | Current Status | Alert Triggered |
|----------------|----------------|-----------------|
| Available | Degraded | ✅ Yes |
| Available | Unavailable | ✅ Yes |
| Degraded | Available | ❌ No |
| Unavailable | Available | ❌ No |
| Degraded | Unavailable | ❌ No |
| Unavailable | Degraded | ❌ No |

## Monitored Resource Types

When `resource_types` is not specified (null), the alert monitors **all resource types** in the specified resource group.

Common resource types you might want to monitor:

- `Microsoft.Compute/virtualMachines`
- `Microsoft.Storage/storageAccounts`
- `Microsoft.KeyVault/vaults`
- `Microsoft.Network/applicationGateways`
- `Microsoft.Network/loadBalancers`
- `Microsoft.Network/networkSecurityGroups`
- `Microsoft.Network/publicIPAddresses`
- `Microsoft.Network/virtualNetworks`
- `Microsoft.Sql/servers`
- `Microsoft.Web/sites`

## Alert Scope

The alert is scoped to:
- **Subscription Level**: Monitors resources across the entire subscription
- **Resource Group Filter**: Only triggers for resources in the specified resource group
- **Resource Type Filter**: (Optional) Only triggers for specified resource types

## Action Group Requirements

The module requires an existing Azure Monitor Action Group. The Action Group should be configured with appropriate notification methods such as:

- Email notifications
- SMS notifications
- Webhook integrations
- Logic App integrations
- Azure Functions

## Tagging

All created resources are automatically tagged with:

- `project`: The project name
- `environment`: The environment name
- `terraform`: "yes"

## License

This module is maintained by the infrastructure team.