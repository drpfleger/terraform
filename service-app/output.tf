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
