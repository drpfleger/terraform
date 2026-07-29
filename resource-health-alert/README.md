# Resource Health Alert Module

This Terraform module creates Azure Monitor activity log alerts for Resource Health and (optionally) Service Health.

## Scope and Subscription Model

- Monitoring is always scoped to `subscription_id`.
- The module is intended to monitor the same subscription where resources are deployed.
- Cross-subscription monitoring is not part of this module design.

## Features

- ResourceHealth alert with subscription-wide monitoring as the default behavior.
- Optional ResourceHealth filtering by one resource group or a list of resource groups.
- Optional ServiceHealth alert with configurable events, services, and locations.
- Action group integration for both alert types.
- Backward-compatible resource naming for the existing ResourceHealth alert.

## File Structure

- `resource-health.tf`: ResourceHealth alert definition.
- `service-health.tf`: ServiceHealth alert definition.

## Usage

### Default Subscription-Wide ResourceHealth

```hcl
module "resource_health_alert" {
  source = "github.com/drpfleger/terraform/resource-health-alert"

  subscription_id      = "12345678-1234-1234-1234-123456789012"
  project              = "myproject"
  environment          = "dev"
  resource_group_name  = "rg-myproject-dev"
  action_group_id      = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-alerts"
}
```

### Legacy Resource Group Filter Mode

```hcl
module "resource_health_alert" {
  source = "github.com/drpfleger/terraform/resource-health-alert"

  subscription_id             = "12345678-1234-1234-1234-123456789012"
  project                     = "myproject"
  environment                 = "dev"
  resource_group_name         = "rg-myproject-dev"
  action_group_id             = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-alerts"
  resource_health_scope_mode  = "resource_group"
}
```

### ResourceHealth Filtered to Multiple Resource Groups

```hcl
module "resource_health_alert" {
  source = "github.com/drpfleger/terraform/resource-health-alert"

  subscription_id            = "12345678-1234-1234-1234-123456789012"
  project                    = "myproject"
  environment                = "dev"
  resource_group_name        = "rg-myproject-dev"
  action_group_id            = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-alerts"
  resource_health_scope_mode = "resource_groups"
  monitored_resource_groups  = ["rg-myproject-dev", "rg-myproject-shared"]
}
```

### Enable ServiceHealth

```hcl
module "resource_health_alert" {
  source = "github.com/drpfleger/terraform/resource-health-alert"

  subscription_id             = "12345678-1234-1234-1234-123456789012"
  project                     = "myproject"
  environment                 = "dev"
  resource_group_name         = "rg-myproject-dev"
  action_group_id             = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-alerts"

  enable_service_health_alert = true
  service_health_events       = ["Incident", "Maintenance", "ActionRequired", "Security"]
  service_health_locations    = ["westeurope", "global"]
}
```

### ServiceHealth Only

```hcl
module "resource_health_alert" {
  source = "github.com/drpfleger/terraform/resource-health-alert"

  subscription_id              = "12345678-1234-1234-1234-123456789012"
  project                      = "myproject"
  environment                  = "dev"
  resource_group_name          = "rg-myproject-dev"
  action_group_id              = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-alerts"

  create_resource_health_alert = false
  enable_service_health_alert  = true
}
```

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= 1.0  |
| azurerm   | >= 4.0  |

## Providers

| Name    | Version |
| ------- | ------- |
| azurerm | >= 4.0  |

## Resources

| Name                                                             | Type        |
| ---------------------------------------------------------------- | ----------- |
| azurerm_monitor_activity_log_alert.default_health_status         | resource    |
| azurerm_monitor_activity_log_alert.default_service_health_status | resource    |
| azurerm_resource_group.main                                      | data source |

## Inputs

| Name                         | Description                                                                      | Type           | Default                                                     | Required |
| ---------------------------- | -------------------------------------------------------------------------------- | -------------- | ----------------------------------------------------------- | -------- |
| subscription_id              | Azure subscription ID used for monitoring scope                                  | `string`       | n/a                                                         | yes      |
| project                      | Project name                                                                     | `string`       | n/a                                                         | yes      |
| environment                  | Environment/stage                                                                | `string`       | n/a                                                         | yes      |
| resource_group_name          | Resource group where alert resources are created                                 | `string`       | n/a                                                         | yes      |
| action_group_id              | Action group ID used by the alerts                                               | `string`       | n/a                                                         | yes      |
| resource_types               | Optional resource type filter for ResourceHealth                                 | `list(string)` | `null`                                                      | no       |
| create_resource_health_alert | Create ResourceHealth alert resource                                             | `bool`         | `true`                                                      | no       |
| enable_health_alert          | Enable or disable ResourceHealth alert when created                              | `bool`         | `true`                                                      | no       |
| resource_health_scope_mode   | ResourceHealth filter mode (`subscription`, `resource_group`, `resource_groups`) | `string`       | `"subscription"`                                            | no       |
| monitored_resource_groups    | Resource groups to monitor when scope mode is `resource_groups`                  | `list(string)` | `null`                                                      | no       |
| enable_service_health_alert  | Create ServiceHealth alert resource                                              | `bool`         | `false`                                                     | no       |
| service_health_events        | ServiceHealth events to monitor                                                  | `list(string)` | `["Incident", "Maintenance", "ActionRequired", "Security"]` | no       |
| service_health_services      | Optional Azure services filter for ServiceHealth                                 | `list(string)` | `null`                                                      | no       |
| service_health_locations     | Optional Azure locations filter for ServiceHealth                                | `list(string)` | `null`                                                      | no       |

## Outputs

| Name                       | Description                      |
| -------------------------- | -------------------------------- |
| resource_health_alert_id   | ID of the ResourceHealth alert   |
| resource_health_alert_name | Name of the ResourceHealth alert |
| service_health_alert_id    | ID of the ServiceHealth alert    |
| service_health_alert_name  | Name of the ServiceHealth alert  |

## Naming Conventions

- ResourceHealth alert: `ar-{project}-{environment}`
- ServiceHealth alert: `ar-{project}-{environment}-sh`

## ResourceHealth Transitions

The ResourceHealth alert monitors the following transition:

- Previous: `Available`
- Current: `Degraded` or `Unavailable`

## Tagging

All created resources are tagged with:

- `project`
- `environment`
- `terraform = "yes"`

## License

This module is maintained by the infrastructure team.
