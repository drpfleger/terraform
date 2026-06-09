resource "azuread_service_principal" "main" {
  client_id = azuread_application.main.client_id

  account_enabled              = var.enabled_for_sign_in # App enabled for sign in?
  app_role_assignment_required = var.assignment_required
  description                  = var.description
  owners                       = local.owner_object_ids
}
