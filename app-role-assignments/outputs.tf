output "assignment_ids" {
  description = "App role assignment IDs keyed by the assignment names from app_role_assignments."
  value       = { for assignment_name, assignment in azuread_app_role_assignment.main : assignment_name => assignment.id }
}
