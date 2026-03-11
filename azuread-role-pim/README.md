# PIM Entra Directory Roles Module (`azuread-role-pim`)

## Purpose

This module manages Privileged Identity Management (PIM) for Entra Directory roles, automating eligibility and activation policies for directory roles.

## How to Use

### 1. Define User Teams

First, define your user teams in a `locals` block. Example:

```hcl
locals {
  high_priv_admins = {
    users = [
      "admin@your-domain.com",
      "user@your-domain.com"
    ]
  }
  billing_admins = {
    users = [
      "billing@your-domain.com",
    ]
  }
  # ... add more teams as needed ...
}
```

### 2. Use the Module for Each Role

Call the module for each PIM configuration you want to manage. Example:

```hcl
module "pim_globalAdmin" {
  source             = "github.com/drpfleger/terraform/azuread-role-pim"
  configuration_name = "GlobalAdmin"
  roles              = ["Global Administrator"]
  active_members     = []
  eligible_members   = local.high_priv_admins.users
  privilege_level    = "High"

  max_activation_duration = "PT2H"
  require_mfa             = true
  require_justification   = true
  require_approval        = true

  send_admin_notifications    = true
  send_approver_notifications = true
  send_assignee_notifications = true
}

module "pim_billing" {
  source             = "github.com/drpfleger/terraform/azuread-role-pim"
  configuration_name = "Billing"
  roles              = ["Billing Administrator"]
  active_members     = []
  eligible_members   = local.billing_admins.users
  privilege_level    = "Med"

  max_activation_duration = "PT10H"
  require_approval        = false
  require_mfa             = true
  require_justification   = false

  send_admin_notifications    = false
  send_approver_notifications = false
  send_assignee_notifications = false
}
```

### 3. Variable Reference

You can reference any team defined in your `locals` block for `eligible_members` or `active_members`.

### 4. Module Variables

- `configuration_name`: Name for the PIM configuration.
- `roles`: List of Entra Directory roles to manage.
- `active_members`: List of users with active membership.
- `eligible_members`: List of users eligible for PIM activation.
- `privilege_level`: Level of privilege (e.g., High, Med, Low).
- `max_activation_duration`: Maximum duration for activation (ISO8601 format).
- `require_mfa`: Require MFA for activation.
- `require_justification`: Require justification for activation.
- `require_approval`: Require approval for activation.
- `send_admin_notifications`: Send notifications to admins.
- `send_approver_notifications`: Send notifications to approvers.
- `send_assignee_notifications`: Send notifications to assignees.

## Tips

- Use local variables for user lists to simplify management.
- Customize module parameters for each role as needed.
