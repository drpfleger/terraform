# Entra App Role Assignments

Assign existing Microsoft Entra application roles to users, security groups, or service principals.

The module does not create applications, service principals, app roles, or groups. It verifies the supplied resource and principal object IDs through AzureAD data sources before creating assignments. Role values are resolved against the target resource service principal and fail validation if the role is not defined there.

## Requirements

- Terraform `>= 1.9.0`
- `hashicorp/azuread` `>= 3.0.0`
- The Terraform identity must be permitted to read the target service principal and assigned principals, and create app role assignments. A user identity typically needs Application Administrator; a service principal requires appropriate Microsoft Graph application permissions, such as `AppRoleAssignment.ReadWrite.All` with the required directory/application read permission.

## Usage

```hcl
module "api_reader_assignment" {
  source = "github.com/drpfleger/terraform//app-role-assignments"

  resource_service_principal_object_id = var.api_service_principal_object_id

  app_role_assignments = {
    readers = {
      app_role_value      = "Example.Api.Reader"
      principal_object_id = var.reader_group_object_id
      principal_type      = "Group"
    }
  }
}
```

For multiple assignments, add entries to `app_role_assignments`. `principal_type` must be `Group`, `User`, or `ServicePrincipal`. The referenced role must already be defined on the resource service principal.

## Inputs

| Name                                   | Description                                                                                                            | Type          | Default |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------------- | ------- |
| `resource_service_principal_object_id` | Object ID of the resource service principal that defines the app roles.                                                | `string`      | n/a     |
| `app_role_assignments`                 | Map of assignments, each containing an app role value, principal object ID, principal type, and optional enabled flag. | `map(object)` | `{}`    |

## Outputs

| Name             | Description                                            |
| ---------------- | ------------------------------------------------------ |
| `assignment_ids` | App role assignment IDs keyed by the assignment names. |

Group membership is intentionally outside this module; manage it with a separate group membership module or process.
