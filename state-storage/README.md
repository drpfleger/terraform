# State Storage Module

This Terraform module creates an Azure Storage Account and container specifically designed for storing Terraform state files. It provides a secure, reliable backend for Terraform state management with configurable retention policies and diagnostic settings integration.

## Features

- **Terraform State Storage**: Dedicated storage account and container for Terraform state files
- **Configurable Retention**: Optional blob and container delete retention policies
- **Manual Deployment**: Designed for manual application outside of standard pipelines
- **Diagnostic Settings Integration**: Optional integration with Log Analytics workspace
- **Security Focused**: Configurable public access controls
- **Standard Configuration**: Uses LRS replication and StorageV2 account type

## Usage

### Basic Usage

```hcl
module "state_storage" {
  source = "github.com/drpfleger/terraform/state-storage"

  resource_group_name = "rg-myproject-dev"
  location           = "westeurope"
  project            = "myproject"
  environment        = "dev"
  subscription_id    = "12345678-1234-1234-1234-123456789012"
}
```

### With Custom Storage Account Name

```hcl
module "state_storage" {
  source = "github.com/drpfleger/terraform/state-storage"

  resource_group_name = "rg-myproject-dev"
  location           = "westeurope"
  project            = "myproject"
  environment        = "dev"
  subscription_id    = "12345678-1234-1234-1234-123456789012"

  override_storage_account_name = "stomyprojectstatedev"
}
```

### With Retention Policies

```hcl
module "state_storage" {
  source = "github.com/drpfleger/terraform/state-storage"

  resource_group_name = "rg-myproject-dev"
  location           = "westeurope"
  project            = "myproject"
  environment        = "dev"
  subscription_id    = "12345678-1234-1234-1234-123456789012"

  delete_retention_blob_in_days      = 30
  delete_retention_container_in_days = 7
  allow_blob_anonymous_access        = false
}
```

### With Diagnostic Settings

```hcl
module "state_storage" {
  source = "github.com/drpfleger/terraform/state-storage"

  resource_group_name = "rg-myproject-dev"
  location           = "westeurope"
  project            = "myproject"
  environment        = "dev"
  subscription_id    = "12345678-1234-1234-1234-123456789012"

  use_diagnostic_settings         = true
  log_analytics_name             = "log-analytics-workspace"
  log_analytics_subscription     = "monitoring-subscription-id"
  log_analytics_resource_group   = "rg-monitoring"
}
```

## Backend Configuration

After creating the state storage, configure your Terraform backend:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-myproject-dev"
    storage_account_name = "stomyprojectstatedev"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
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
| azurerm | >= 4.31.0 |
| azurerm.log_analytics | >= 4.31.0 |

## Resources

| Name | Type |
|------|------|
| azurerm_storage_account | resource |
| azurerm_storage_container | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| project | The project name | `string` | n/a | yes |
| environment | Environment/Stage | `string` | n/a | yes |
| subscription_id | Subscription Id | `string` | n/a | yes |
| location | Azure resource location | `string` | `"westeurope"` | no |
| override_storage_account_name | Override the storage account name | `string` | `null` | no |
| delete_retention_blob_in_days | Number of days to retain deleted blobs | `number` | `null` | no |
| delete_retention_container_in_days | Number of days to retain deleted containers | `number` | `null` | no |
| allow_blob_anonymous_access | Allow anonymous access to blobs | `bool` | `false` | no |
| use_diagnostic_settings | True when diagnostic settings must be created | `bool` | `false` | no |
| log_analytics_name | Name of the log analytics workspace | `string` | `null` | no |
| log_analytics_subscription | Subscription id of the log analytics workspace | `string` | `null` | no |
| log_analytics_resource_group | Resource group of the log analytics workspace | `string` | `null` | no |

## Outputs

This module does not expose any outputs.

## Naming Conventions

The module follows these naming conventions:

- **Storage Account**: `sto{project}state{environment}`
- **Container**: `tfstate`

## Environment Validation

The module validates that the environment is one of the following allowed values:
- `dev` - Development
- `sbx` - Sandbox
- `tst` - Test
- `prd` - Production
- `main` - Main/Primary
- `nw` - Network Watcher

## Storage Account Configuration

The storage account is configured with the following settings:

| Setting | Value | Purpose |
|---------|-------|---------|
| Account Kind | StorageV2 | Modern storage account type with all features |
| Account Tier | Standard | Cost-effective tier for state storage |
| Replication Type | LRS | Locally redundant storage for cost efficiency |
| Hierarchical Namespace | Disabled | Standard blob storage (not ADLS Gen2) |
| Public Access | Controlled by variable | Security control for blob access |

## Retention Policies

### Blob Delete Retention
- **Purpose**: Protects against accidental deletion of state files
- **Configuration**: Optional, set via `delete_retention_blob_in_days`
- **Recommendation**: 7-30 days for production environments

### Container Delete Retention  
- **Purpose**: Protects against accidental deletion of the tfstate container
- **Configuration**: Optional, set via `delete_retention_container_in_days`
- **Recommendation**: 7 days minimum for production environments

## Security Considerations

### Anonymous Access
- **Default**: Disabled (`allow_blob_anonymous_access = false`)
- **Recommendation**: Keep disabled for security
- **Access Method**: Use Azure AD authentication or access keys

### Network Access
- The module does not configure network restrictions by default
- Consider implementing network access rules in production environments
- Use Azure Private Endpoints for enhanced security

## Diagnostic Settings Integration

When `use_diagnostic_settings = true`, the module requires:
- `log_analytics_name`: Name of the target Log Analytics workspace
- `log_analytics_subscription`: Subscription containing the workspace (defaults to current subscription)
- `log_analytics_resource_group`: Resource group containing the workspace

This enables monitoring and auditing of state storage operations.

## Manual Deployment Note

⚠️ **Important**: This module is designed for manual deployment and should **not** be part of automated pipelines that use the same storage account for state storage (this would create a circular dependency).

## Best Practices

1. **Separate State Storage**: Create state storage in a separate, dedicated resource group
2. **Access Control**: Use Azure AD authentication where possible
3. **Backup Strategy**: Consider additional backup mechanisms for critical state files
4. **Monitoring**: Enable diagnostic settings for audit trails
5. **Retention**: Configure appropriate retention policies for your compliance needs
6. **Environment Separation**: Use separate storage accounts for different environments

## License

This module is maintained by the infrastructure team.