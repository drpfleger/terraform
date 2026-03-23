# Management Group Policy Module

This module creates a custom Azure Policy definition and assigns it to a management group. It is driven by simple JSON policy files.

The idea: create a folder named after the management group and place policy JSON files inside it. The environment code loads and applies everything automatically.

## How it works

Your environment code loads policy JSON files from:

```
management-group-policies/<management-group-name>/*.json
```

Each JSON file defines the policy display name, rule and assignment name. The folder name supplies the management group scope.

### Example policy JSON

Here is the structure used by a policy JSON file:

```json
{
	"assignment_name": "root-https",
	"policy_display_name": "Audit HTTPS Only on App Services",
	"policy_mode": "Indexed",
	"policy_rule": {
		"if": {
			"allOf": [
				{ "field": "type", "equals": "Microsoft.Web/sites" },
				{ "field": "Microsoft.Web/sites/httpsOnly", "equals": false }
			]
		},
		"then": { "effect": "audit" }
	}
}
```

Notes:

- `assignment_name` must be unique in the management group and should stay within 1-24 characters.
- `policy_mode` is usually `Indexed` or `All`.
- `policy_rule` must follow the Azure Policy JSON schema.

## Usage

```hcl
terraform {
  backend "azurerm" {
	[...]
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.65.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "00000000-0000-0000-0000-000000000000"
  features {}
}

locals {
  # Load all JSON files from the management-group-policies folder
  # Subfolder names are used to determine the management group scope
  management_group_policy_files = fileset("${path.module}/management-group-policies", "**/*.json")

  # Normalize the JSON files into a map with necessary inputs for the module
  management_group_policies = {
    for f in local.management_group_policy_files : f => merge(
      jsondecode(file("${path.module}/management-group-policies/${f}")),
      {
        mg_name     = split("/", f)[0]
        policy_name = trimsuffix(basename(f), ".json")
      }
    )
  }
}


module "management_group_policies" {
  for_each = local.management_group_policies
  source   = "github.com/drpfleger/terraform/policies/managementGroup"

  policy_mode         = each.value.policy_mode
  policy_name         = each.value.policy_name
  policy_display_name = each.value.policy_display_name
  policy_rule         = each.value.policy_rule
  assignment_name     = each.value.assignment_name
  management_group_id = each.value.mg_name
}
```

## The environment code is responsible for:

- Discovering the `management-group-policies/<management-group-name>/*.json` files
- Normalizing JSON into the `local.management_group_policies` map
- Supplying the `management_group_id` and other inputs

## Quick start

1. Create a folder under `management-group-policies` named after the target management group.
2. Add one JSON file per policy.
3. Run Terraform for your policies environment.

That is all you need to do.
