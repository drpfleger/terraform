variable "resource_service_principal_object_id" {
  description = "Object ID of the resource service principal that exposes the app roles. The module verifies that it exists in Entra ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.resource_service_principal_object_id))
    error_message = "resource_service_principal_object_id must be a GUID."
  }
}

variable "app_role_assignments" {
  description = "App role assignments keyed by a stable local name. Each principal is verified through the AzureAD provider before assignment."
  type = map(object({
    app_role_value      = string
    principal_object_id = string
    principal_type      = string
    enabled             = optional(bool, true)
  }))
  default = {}

  validation {
    condition = alltrue([
      for assignment in values(var.app_role_assignments) : (
        trimspace(assignment.app_role_value) != "" &&
        can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", assignment.principal_object_id)) &&
        contains(["Group", "User", "ServicePrincipal"], assignment.principal_type)
      )
    ])
    error_message = "Each assignment requires a non-empty app_role_value, a GUID principal_object_id, and principal_type of Group, User, or ServicePrincipal."
  }
}
