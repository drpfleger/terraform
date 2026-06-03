# GitHub Copilot Instructions for drpfleger/terraform

You are assisting in authoring and maintaining Terraform configurations for Azure infrastructure.
Follow these conventions and principles when generating code or documentation.

---

## 🚀 Purpose

- Write Terraform code (HCL) that is valid for Terraform 1.9+.
- Focus on modular, reusable, and consistent infrastructure code.
- Use only the `azurerm`, `azuread`, or `azcli` providers when the requested resources require them; do not add provider blocks for unused providers.

---

## ⚙️ Copilot Behavior

- Always propose valid HCL syntax.
- Prefer using existing project modules instead of defining resources inline.
- If no existing module in this repository explicitly supports the requested resource type (as stated in its README or module description), then define the resources inline using the standard naming and tagging conventions. If module documentation is missing or unclear about support, ask the user to confirm module availability or default to inline resources and state the assumption.
- Use descriptive variable names and outputs aligned with resource purpose.
- Follow Azure resource naming abbreviations (see [Microsoft documentation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)).
- In module code, avoid hardcoded environment-specific settings; use variables, locals, or data sources instead. Fixed literals are allowed for constant tags (e.g., `terraform = "yes"`) and provider-required enum values; otherwise use variables. In documentation examples, use placeholder literals for required inputs or show a `terraform.tfvars` snippet with placeholders.
- Never use hardcoded credentials, or secrets.

---

## 📦 Code Quality

- Format all Terraform files using `terraform fmt`.
- Ensure generated code passes `terraform validate`.
- Prefer readable, minimal code — avoid redundant blocks or comments.
- Use locals for computed values and keep variables meaningful and type-safe.
- Always include `description` and `type` for variables, and mark sensitive values as `sensitive = true`.
  Add validation blocks for variables with constrained values (for example, enums, length limits, or formats).

---

## 🧩 Module Structure

Each module should contain:

- `variables.tf` – input variables
- `outputs.tf` – outputs (optional)
- `providers.tf` – Terraform and provider versions
- `namings.tf` – naming conventions and standards
- `locals.tf` – local values and computed attributes
- `readme.md` – module documentation
- `meta.tf` – module metadata (optional)
- `[resource].tf` – resource definitions (e.g. `resource-group.tf`, `rbac.tf`)

Modules should do **one thing well**.
If a module grows too large, propose splitting it into smaller submodules.

---

## 🧱 Naming Conventions

- Use lowercase and underscores (`_`) for variables and outputs.
- Avoid repeating the resource type in names.
- Tag all resources consistently. Use predefined tags in `locals.tf` like so:
- If a resource type does not support tags, omit the `tags` block for that resource and note the exception in the module README.

```hcl
locals {
  # Predefined tags
  required_tags = {
    project     = var.project
    environment = var.environment,
    terraform   = "yes"
  }
}
```

---

## 🔍 Best Practices

- Use `tflint` and `tfsec` for static analysis.
- Use data sources (`data "..."`) instead of hardcoded values when referencing existing resources.
- Favor loops (`for_each`, `count`) over manual duplication.

---

## 🧠 Examples

When showing examples:

- Demonstrate proper module usage, including inputs and outputs.
- Provide clear, minimal `terraform` snippets.
- Use realistic but non-sensitive placeholder values.

---

## ⚠️ Security and Compliance

- Never include API keys, passwords, or secrets.
- Use secure variable inputs or reference a secret manager (e.g., Azure Key Vault).
- Do not expose sensitive outputs.

---

## 🧩 Contribution Rules

- Use meaningful commit messages.
- Maintain backward compatibility when altering modules.

---

## ✅ Summary

Generate Terraform code that is:

- Valid, modular, and reusable
- Provider-compatible
- Secure, formatted, and validated
- Consistent with drpfleger’s naming and structural conventions
