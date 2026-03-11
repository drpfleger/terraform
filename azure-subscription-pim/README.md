# PIM Azure Admin Module (`azure-subscription-pim`)

## Purpose

This module manages Privileged Identity Management (PIM) for Azure Admin groups, automating group membership and eligibility for Azure roles.

## How to Use

### 1. Define User Teams

First, define your user teams in a `locals` block. Example:

```hcl
locals {
  dev_team = {
    users = [
      "developer@your-domain.com"
    ]
  }
  ops_team = {
    users = [
      "admin@your-domain.com",
    ]
  }
  # ... add more teams as needed ...
}
```

### 2. Create a Local Config for Admin Groups

Define a config map for your admin groups:

```hcl
locals {
  config = {
    subscription1-admin = {
      eligible_members = local.ops_team.users
    }
    subscription2-admin = {
      eligible_members = concat(local.dev_team.users, local.ops_team.users)
    }
    sandbox = {
      active_members = local.dev_team.users
    }
    # ... add more groups as needed ...
  }
}
```

### 3. Use the Module for Each Admin Group

Call the module using `for_each` for scalable management:

```hcl
module "pim_az" {
  for_each = local.config

  source           = "github.com/drpfleger/terraform/azure-subscription-pim"
  admin_group_name = each.key
  active_members   = contains(keys(each.value), "active_members") ? each.value.active_members : []
  eligible_members = contains(keys(each.value), "eligible_members") ? each.value.eligible_members : []
}
```

### 4. Customization

You can add custom variables for special cases:

```hcl
module "pim_az_root_admin" {
  source                = "github.com/drpfleger/terraform/azure-subscription-pim"
  admin_group_name      = "root-admin"
  eligible_members      = concat(local.dev_team.users, local.ops_team.users)
  require_approval      = true
  require_justification = true
}
```

### 5. Module Variables

- `admin_group_name`: Name of the Azure admin group.
- `active_members`: List of users with active membership.
- `eligible_members`: List of users eligible for PIM activation.
- Custom variables (optional): `require_approval`, `require_justification`, etc.

## Tips

- Use the `for_each` pattern for scalable group management.
- Reference user lists from local variables for maintainability.
