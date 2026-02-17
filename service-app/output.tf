output "application_id" {
  value       = azuread_application.main.id
  description = "The ID of the Entra Id application."
}

output "application_object_id" {
  value       = azuread_application.main.object_id
  description = "The object ID of the Entra Id application."
}

output "application_client_id" {
  value       = azuread_application.main.client_id
  description = "The client ID of the Entra Id application."
}

output "application_name" {
  value       = azuread_application.main.display_name
  description = "The display name of the Entra Id application."
}

output "service_principal_id" {
  value       = azuread_service_principal.main.id
  description = "The ID of the Entra Id service principal."
}

output "service_principal_object_id" {
  value       = azuread_service_principal.main.object_id
  description = "The object ID of the Entra Id service principal."
}

output "app_role_ids" {
  value = {
    for key, role in azuread_application_app_role.main :
    role.value => role.role_id
  }
  description = "The mapping of app role values to role IDs of this application. Useful for getting role ID by value lookup."
}

output "app_scope_ids" {
  value       = azuread_service_principal.main.oauth2_permission_scope_ids
  description = "The mapping of scope values to IDs of this service principal. Useful for getting scope ID by name lookup."
}
