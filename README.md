# Terraform Azure Infrastructure Modules

This repository contains a collection of reusable Terraform modules for Azure infrastructure deployment. Each module is designed to follow Azure best practices, provide secure defaults, and support common enterprise scenarios.

## 🚀 Purpose

These modules are designed to:
- Accelerate Azure infrastructure deployment with reusable, tested components
- Enforce consistent naming conventions and tagging across resources
- Provide secure, enterprise-ready configurations
- Support cross-subscription scenarios (e.g., centralized monitoring)
- Integrate seamlessly with Azure Monitor and Log Analytics

## 📦 Available Modules

| Module | Description | Status |
|--------|-------------|--------|
| [**main-resource-group**](./main-resource-group/) | Central resource group with Key Vault, admin groups, network watcher, and optional budget/health monitoring | ✅ Ready |
| [**diagnostic-settings**](./diagnostic-settings/) | Azure Monitor diagnostic settings for log and metric collection | ✅ Ready |
| [**service-app**](./service-app/) | Azure AD service application with configurable permissions and RBAC | ✅ Ready |
| [**resource-health-alert**](./resource-health-alert/) | Resource health monitoring with activity log alerts | ✅ Ready |
| [**state-storage**](./state-storage/) | Terraform state storage with configurable retention and security | ✅ Ready |

## 🏗️ Module Structure

Each module follows a consistent structure:

```
module-name/
├── README.md              # Module documentation
├── variables.tf           # Input variables
├── outputs.tf            # Output values (optional)
├── providers.tf          # Provider requirements and configuration
├── namings.tf            # Naming conventions and standards
├── locals.tf             # Local values and computed attributes
├── meta.tf              # Module metadata (optional)
└── [resource].tf        # Resource definitions (e.g., storage.tf, keyvault.tf)
```

## 🔧 Quick Start

### 1. Basic Infrastructure Setup

Start with the main resource group module for core infrastructure:

```hcl
module "main_infrastructure" {
  source = "github.com/drpfleger/terraform/main-resource-group"

  main_resource_group_name = "rg-myproject-dev"
  location                 = "westeurope"
  project                  = "myproject"
  environment              = "dev"
  subscription_id          = "12345678-1234-1234-1234-123456789012"
}
```

### 2. Add Monitoring

Enable diagnostic settings for your resources:

```hcl
module "diagnostic_settings" {
  source = "github.com/drpfleger/terraform/diagnostic-settings"

  providers = {
    azurerm.target        = azurerm
    azurerm.log_analytics = azurerm.monitoring
  }

  target_resource_id           = azurerm_storage_account.example.id
  log_analytics_name           = "log-analytics-workspace"
  log_analytics_resource_group = "rg-monitoring"
}
```

### 3. Create Service Applications

Set up Azure AD applications with proper permissions:

```hcl
module "api_service_app" {
  source = "github.com/drpfleger/terraform/service-app"

  project                = "myproject"
  environment            = "dev"
  app_type               = "api"
  description            = "API service application"
  is_confidential_client = true
  use_password           = true
  use_certificate        = false
  key_vault_id           = module.main_infrastructure.key_vault_id
}
```

## 🏷️ Naming Conventions

All modules follow consistent naming patterns based on [Microsoft's Azure naming conventions](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations):

| Resource Type | Pattern | Example |
|---------------|---------|---------|
| Resource Group | `rg-{project}-{environment}` | `rg-myproject-dev` |
| Key Vault | `kvt-{project}-{environment}` | `kvt-myproject-dev` |
| Storage Account | `sto{project}{purpose}{environment}` | `stomyprojectstatedev` |
| Network Watcher | `nw-{project}` | `nw-myproject` |
| Action Group | `agrp-{project}` | `agrp-myproject` |

## 🔐 Security & Compliance

### Tagging Strategy

All resources are automatically tagged with:

```hcl
locals {
  required_tags = {
    project     = var.project
    environment = var.environment
    terraform   = "yes"
  }
}
```

### Security Features

- **Key Vault Integration**: Secure storage for secrets and certificates
- **RBAC Authorization**: Role-based access control on all resources
- **Diagnostic Logging**: Comprehensive audit trails via Azure Monitor
- **Network Security**: Configurable public access controls
- **Retention Policies**: Configurable data retention for compliance

## ⚙️ Provider Requirements

### Core Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9 |
| azurerm | >= 4.31.0 |
| azuread | >= 3.0 |

### Cross-Subscription Scenarios

Many modules support cross-subscription deployments. Configure multiple providers:

```hcl
# Target subscription (where resources will be created)
provider "azurerm" {
  subscription_id = "target-subscription-id"
  features {}
}

# Monitoring subscription (where Log Analytics workspace exists)
provider "azurerm" {
  alias           = "monitoring"
  subscription_id = "monitoring-subscription-id"
  features {}
}
```

## 🌍 Environment Support

Supported environments with validation:

- `dev` - Development
- `sbx` - Sandbox  
- `tst` - Test
- `prd` - Production
- `main` - Main/Primary
- `nw` - Network Watcher

## 📚 Usage Patterns

### Pattern 1: Complete Infrastructure Stack

```hcl
# Core infrastructure
module "main_infrastructure" {
  source = "github.com/drpfleger/terraform/main-resource-group"
  
  main_resource_group_name = "rg-myproject-dev"
  project                  = "myproject"
  environment              = "dev"
  subscription_id          = var.subscription_id
  
  enable_budget              = true
  budget_amount              = 1000
  alert_email_receivers      = ["admin@company.com"]
  enable_resource_health_alert = true
}

# State storage (deploy separately)
module "state_storage" {
  source = "github.com/drpfleger/terraform/state-storage"
  
  resource_group_name = "rg-terraform-state"
  project            = "myproject"
  environment        = "dev"
  subscription_id    = var.subscription_id
  
  delete_retention_blob_in_days = 30
}

# Service application
module "api_app" {
  source = "github.com/drpfleger/terraform/service-app"
  
  project                = "myproject"
  environment            = "dev"
  app_type               = "api"
  description            = "Main API service"
  is_confidential_client = true
  use_password           = true
  key_vault_id           = module.main_infrastructure.key_vault_id
}
```

### Pattern 2: Monitoring Integration

```hcl
# Enable diagnostics for multiple resources
module "storage_diagnostics" {
  source = "github.com/drpfleger/terraform/diagnostic-settings"
  
  providers = {
    azurerm.target        = azurerm
    azurerm.log_analytics = azurerm.monitoring
  }
  
  target_resource_id           = azurerm_storage_account.app.id
  log_analytics_name           = "central-log-workspace"
  log_analytics_resource_group = "rg-monitoring"
}

module "keyvault_diagnostics" {
  source = "github.com/drpfleger/terraform/diagnostic-settings"
  
  providers = {
    azurerm.target        = azurerm
    azurerm.log_analytics = azurerm.monitoring
  }
  
  target_resource_id           = module.main_infrastructure.key_vault_id
  log_analytics_name           = "central-log-workspace"
  log_analytics_resource_group = "rg-monitoring"
  
  user_defined_category_groups = ["audit", "allLogs"]
}
```

## 🛠️ Development Guidelines

### Code Quality

- Format all code with `terraform fmt`
- Validate syntax with `terraform validate`
- Use meaningful variable names and descriptions
- Include type validation where applicable
- Mark sensitive variables as `sensitive = true`

### Documentation

- Update module README.md for any changes
- Include usage examples
- Document all variables and outputs
- Explain any special considerations

### Testing

- Test modules in development environments
- Validate cross-subscription scenarios
- Verify naming conventions
- Test with different variable combinations

## 🤝 Contributing

When contributing to this repository:

1. Follow existing module structure and conventions
2. Maintain backward compatibility
3. Update documentation for any changes
4. Use meaningful commit messages
5. Test changes thoroughly before submitting

## 📄 License

This repository is maintained by the drpfleger infrastructure team. All modules are designed for internal use and follow enterprise security standards.
