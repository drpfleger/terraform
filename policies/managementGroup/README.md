# Management Group Policy Module

This module creates a custom Azure Policy definition at a specified management group scope and assigns it to one or more management groups. It is driven by variables and supports assignment to multiple management groups.

## How it works

Your environment code loads policy JSON files from:

```
management-group-policies/<management-group-name>/*.json
```

Each JSON file defines policy and assignment inputs. The folder name supplies the management group where the policy definition is created.

### Example policy JSON

Here is the structure used by a policy JSON file with the name `enforce-https.json`:

```json
{
	"assignment_management_group_ids": [
		"landing-zone-management-group",
		"platform-management-group"
	],
	"assignment_name": "root-https",
	"assignment_display_name": "Audit HTTPS Only",
	"assignment_description": "Audits App Services that do not enforce HTTPS.",
	"policy_display_name": "Audit HTTPS Only on App Services",
	"policy_mode": "All",
	"policy_rule": {
		"if": {
			"allOf": [
				{
					"field": "type",
					"equals": "Microsoft.Web/sites"
				},
				{
					"field": "Microsoft.Web/sites/httpsOnly",
					"equals": false
				}
			]
		},
		"then": {
			"effect": "audit"
		}
	},
	"meta_data": {
		"category": "Security"
	}
}
```

Notes:

- `policy_name` is derived from the JSON file name and should be unique in the management group. Use a descriptive name that reflects the policy's purpose.
- `assignment_name` must be unique in the management group and should stay within 1-24 characters.
- `assignment_management_group_ids` contains management group names (group_id values) used as assignment targets.
- `policy_mode` is usually `Indexed` or `All`.
- `policy_rule` must be a structured JSON object that follows the Azure Policy JSON schema.
- `meta_data` is optional and can include additional information about the policy definition.
- `assignment_display_name` and `assignment_description` are optional.

## Input contract

Required JSON fields:

- `assignment_management_group_ids` (list of management group names/group_id values)
- `assignment_name` (string, 1-24 chars)
- `policy_display_name` (string)
- `policy_mode` (string)
- `policy_rule` (object)

Optional JSON fields:

- `assignment_display_name` (string)
- `assignment_description` (string)
- `meta_data` (object)

Derived by environment code (not part of JSON):

- `definition_management_group` from folder name `management-group-policies/<management-group-name>/...`
- `policy_name` from JSON file name without `.json`

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
  # Subfolder names are used to determine the management group where the policy is defined
  management_group_policy_files = fileset("${path.module}/management-group-policies", "**/*.json")

  # Normalize the JSON files into a map with necessary inputs for the module
  # External JSON uses assignment_management_group_ids;
  # module input expects assignment_management_groups.
  management_group_policies = {
    for f in local.management_group_policy_files : f => merge(
      jsondecode(file("${path.module}/management-group-policies/${f}")),
      {
        definition_management_group  = split("/", f)[0]
        policy_name                  = trimsuffix(basename(f), ".json")
        assignment_management_groups = jsondecode(file("${path.module}/management-group-policies/${f}")).assignment_management_group_ids
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
  meta_data           = try(each.value.meta_data, null)
  assignment_name     = each.value.assignment_name
  assignment_display_name      = try(each.value.assignment_display_name, "")
  assignment_description       = try(each.value.assignment_description, "")
  assignment_management_groups = each.value.assignment_management_groups
  definition_management_group  = each.value.definition_management_group
}
```

## The environment code is responsible for:

- Discovering the `management-group-policies/<management-group-name>/*.json` files
- Normalizing JSON into the `local.management_group_policies` map
- Mapping `assignment_management_group_ids` to `assignment_management_groups`
- Supplying `definition_management_group`, `assignment_management_groups`, and other module inputs

## Quick start

1. Create a folder under `management-group-policies` named after the target management group.
2. Add one JSON file per policy.
3. Run Terraform for your policies environment.

That is all you need to do.
