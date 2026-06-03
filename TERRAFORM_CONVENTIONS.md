# Terraform Operating Conventions

This document defines the mandatory Terraform conventions used across our repositories.
It is written for both humans and agents. Rules use RFC-style keywords: MUST, SHOULD, MUST NOT.

## 0. Scope

These conventions apply to:

- stage/environment naming
- Azure resource naming
- Terraform resource block naming
- repository/module folder structure

## 1. Stage Conventions

### 1.1 Allowed Stage Tokens

The only allowed stage tokens are:

- dev
- sbx
- tst
- prd
- main

### 1.2 Stage Semantics

- `dev`: development stage
- `sbx`: sandbox stage
- `tst`: test stage
- `prd`: production stage
- `main`: shared/bootstrap stage (not an alias for `prd`)

### 1.3 Terraform Variable Name

The stage variable MUST be named `environment`.

## 2. Azure Resource Naming

### 2.1 General Rules

- Resource names MUST be lowercase.
- Hyphenated names MUST follow this pattern: `<prefix>-<project>-<environment>[-<qualifier>]`.
- `project` MUST be a short, stable project code.
- `environment` MUST use one of the allowed tokens from section 1.

### 2.2 Standard Prefixes

Core prefixes:

- Resource Group: `rg-`
- Key Vault: `kvt-`
- Action Group: `agrp-`
- Virtual Network: `vnet-`
- Subnet: `snet-`
- Storage Account base: `sto` (without hyphen because of Azure storage constraints)
- Network Watcher: `nw-`
- Budget: `budget-monthly-`

Common prefixes used across multiple repositories:

- Private Endpoint: `pve-`
- Public IP: `pip-`
- Managed Identity: `mgid-`
- DNS: `dns-`
- DNS profile/resolver: `dnspr-`
- Service Bus: `sb-`
- SQL: `sql-`
- Logging/monitoring: `log-`
- App/service family: `fc-`
- Monitoring resources: `amr-`
- Application Insights: `appi-`
- App Service Plan Linux: `asp-lnx-`
- Function App: `func-`
- AI/Cognitive family: `ai-`
- Application Gateway: `agw-`
- Firewall: `fw-`
- Network Security Group: `nsg-`
- Alert rule: `ar-`
- Azure Kubernetes Service: `aks-`
- Azure Managed Redis: `amr-`
- Container Registry: `crdrpf`

Additional project-specific prefixes currently in use (allowed when module-specific and documented):

- `fwp-`, `fwprc-`, `vpng-`, `lng-`, `vmss-`, `nic-vmss-`, `dcr-`, `dce-`, `law-link-`, `mpls-`, `apls-`, `acs-`, `aces-`, `ea-`, `con-drpf-primary-`

### 2.3 Special Rules for Length/Character-Constrained Names

Storage account names:

- MUST be globally unique.
- MUST be between 3 and 24 characters.
- MUST contain only lowercase letters and numbers.
- MUST NOT contain hyphens, underscores, spaces, or other special characters.
- SHOULD follow: `sto<project><purpose><environment>`.
- If the generated name would exceed 24 characters, abbreviate `project` and/or `purpose` deterministically.

App registrations (Microsoft Entra, `azuread_application` `display_name`):

- MUST NOT exceed 256 characters.
- Azure allows broader character sets, but our convention SHOULD avoid special characters.
- For cross-repo consistency, app registration names SHOULD use lowercase letters, numbers, and hyphens.
- Recommended shape: `app-<project>-<purpose>-<environment>` or an approved module prefix style.

Example: `stocblstatedev`

### 2.4 Examples

- `rg-cbl-dev`
- `kvt-cbl-prd`
- `vnet-cbl-main-hub`
- `snet-cbl-main-app`
- `agrp-cbl`
- `stocblstatedev`

## 3. Terraform Resource Naming

### 3.1 Resource Type Naming

Resource types MUST use the full provider type, for example:

- `azurerm_resource_group`
- `azurerm_key_vault`
- `azurerm_monitor_action_group`

### 3.2 Resource Label Naming

- Use `main` for singleton resources in a module.
- Use descriptive `snake_case` labels for non-singletons.
- Labels MUST use only lowercase letters, digits, and underscores.
- Labels MUST NOT contain hyphens.

### 3.3 Recommended Pattern for Descriptive Labels

Use:

- `<owner>_<scope>_<purpose>`

Examples:

- `network_spoke_route_table`
- `identity_keyvault_reader`
- `monitor_default_health_alert`

### 3.4 Terraform Examples

```hcl
resource "azurerm_resource_group" "main" {
  name = local.resource_group_name
}

resource "azurerm_key_vault_access_policy" "identity_keyvault_reader" {
  key_vault_id = azurerm_key_vault.main.id
}
```

## 4. Standard Repository Structure

The standard structure is:

```text
terraform/
  environments/
    <project>/
      main/
      dev/
      sbx/
      tst/
      prd/
  modules/
    <module_name>/
      main.tf
      variables.tf
      outputs.tf
      providers.tf
      locals.tf
      namings.tf
      README.md
```

Notes:

- `main` is the shared/bootstrap layer.
- Not every project must use every stage folder, but names MUST follow section 1.

## 5. Compliance Rules (Quick Checklist)

A change is compliant only if all checks pass:

- stage token is one of: dev, sbx, tst, prd, main
- stage variable name is `environment`
- Azure names use approved prefixes and stage token placement
- storage account naming is alphanumeric and follows the standard pattern
- app registration names stay within length limits and avoid special characters
- Terraform singleton resources use label `main`
- Terraform non-singleton resources use descriptive `snake_case`
- no hyphenated Terraform resource labels
- repository layout follows `terraform/environments/...` and `terraform/modules/...`

## 6. Legacy and Non-Conformant Variants

The following are classified as legacy/non-compliant:

- stage tokens: `qa`, `prod`
- stage variable name: `env`
- prefixes: `ag-`, `kv-`, `vn-`, `sn-`
- new app registration names with special characters
- Terraform resource labels with hyphens
- repository layouts that do not follow the standard structure

These may exist in older repositories, but MUST NOT be introduced in new code.

## 7. Migration Policy

- New repositories and new modules MUST follow this document immediately.
- Existing modules MUST be aligned when touched for feature changes.
- Legacy areas SHOULD be migrated incrementally with explicit backlog items.

## 8. Agent Usage Note

When generating Terraform code, agents MUST treat this file as the source of truth for naming and structure.
If a repository contains conflicting legacy examples, this document has priority.
