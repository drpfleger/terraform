# optional claims, we currently rarely use it.
# useful to emit group membership in token (saml, id, access)
resource "azuread_application_optional_claims" "main" {
  count = var.define_optional_claims ? 1 : 0

  application_id = azuread_application.main.id

  # Dynamically add optional claims if defined in module call:
  dynamic "access_token" {
    for_each = var.access_token_claims
    content {
      name                  = each.value.name
      essential             = each.value.essential
      source                = each.value.source
      additional_properties = each.value.additional_properties
    }
  }

  dynamic "id_token" {
    for_each = var.id_token_claims
    content {
      name                  = each.value.name
      essential             = each.value.essential
      source                = each.value.source
      additional_properties = each.value.additional_properties
    }
  }

  dynamic "saml2_token" {
    for_each = var.saml2_token_claims
    content {
      name                  = each.value.name
      essential             = each.value.essential
      source                = each.value.source
      additional_properties = each.value.additional_properties
    }
  }
}
