# Set ID URI of the registered App
resource "azuread_application_identifier_uri" "main" {
  application_id = azuread_application.main.id
  identifier_uri = "api://${azuread_application.main.client_id}"
}

resource "azuread_application" "main" {
  display_name            = local.app_name
  description             = var.description
  group_membership_claims = var.group_membership_claims
  owners                  = distinct(concat([data.azuread_client_config.current.object_id], data.azuread_group.project_admin_group.members))
  prevent_duplicate_names = true
  sign_in_audience        = var.sign_in_audience

  # Define OAuth2 permission scopes that client applications can request access to in the name of the user
  # delegated permissions
  # blade "Expose an API" in Azure portal
  api {
    known_client_applications      = var.known_client_applications
    mapped_claims_enabled          = false
    requested_access_token_version = var.access_token_version
    # oauth2_permission_scopes are defined in file: appScopes.tf
  }

  # redirect uri if public client
  public_client {
    redirect_uris = var.public_client_redirect_uris
  }

  # redirect uri if spa
  single_page_application {
    redirect_uris = var.spa_redirect_uris
  }

  web {
    implicit_grant {
      access_token_issuance_enabled = var.implicit_grant.access_token_issuance_enabled
      id_token_issuance_enabled     = var.implicit_grant.id_token_issuance_enabled
    }
    homepage_url  = var.homepage_url
    logout_url    = var.logout_url
    redirect_uris = var.web_redirect_uris
  }

  # Set tags:
  # Hide App from My Apps portal, service apps are always hidden.
  # The "WindowsAzureActiveDirectoryIntegratedApp" = Enterprise App tag is never set for service apps.
  # Define as Terraform managed, project and environment
  tags = ["HideApp", "Terraform", var.project, var.environment]

  # Terrfaform recommends to ignore changes on the following attribute blocks,
  # when the dedicated, equivalent resources are used to manage them.
  lifecycle {
    ignore_changes = [
      identifier_uris,
      api[0].oauth2_permission_scope,
      optional_claims,
      app_role,
      required_resource_access
    ]
  }
}
