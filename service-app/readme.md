# Service App Module

This module defines a service application in Azure Entra Directory using Terraform. Below is the documentation on how to call this module, including the required and optional variables.

## Required Variables

The following variables must be set for the module to work. If the app has no concrete relation to any working project, use a default identity subscription with existing key vault. In our case for example: `subscription_id = "<identity-sub-id>"`, `project = "escorial-id"` and `environment = "main"`.

- `subscription_id`: The subscription ID where the project resource group and key vault are located.
- `project`: The project name this app belongs to.
- `environment`: The deployment environment or stage (i.e., dev, sbx, tst, prd, main).
- `app_type`: The type of the app. This is used to build the display name with schema `project-app_type-environment`.
- `description`: A descriptive text regarding the purpose of this app.
- `is_confidential_client`: Whether this client app is confidential.
- `use_password`/`use_certificate`: If `is_confidential_client` either `use_password` or `use_certificate` must be true, else set both to false.

### Minimal Working Example

```hcl
module "sample_app" {
  source = "github.com/drpfleger/terraform/service-app"

  subscription_id        = "<project-subscription-id>"
  project                = "escorial-id"
  environment            = "main"
  app_type               = "sample-app"
  description            = "This is a sample service app"
  is_confidential_client = true
  use_password           = true
}
```

## Optional Variable Reference

The following variables are optional and have default values: Depending on which kind of app you want to define several different options can be set.

#### Quick Reference:

- If this app requires access to other APIs (e.g. calls to Graph API) have a look at the `api_access` variable.
- If this apps service principal should be assigned an Azure RBAC role have a look at the `rbac_assignments` variable
- To expose scopes and/or roles of for example an API application refer to the `oauth2_scopes` and `app_roles`
- In rare cases it may be required to include optional claims in the tokens issued for this app. To achieve this, configure the `define_optional_claims` and related variables.

The **full list of optional variables** can be found below. Please note that most of these variables are complex types. Refer to the `variables.tf` files of this module to review their structure.

- `password_roatation_days`: Days after which a tf apply will auto-rotate the password. Default is `180`.
- `enabled_for_sign_in`: Whether the service principal is enabled for sign-in. Default is `true`.
- `assignement_required`: Whether an assignment of User/Group is required to use the app. Default is `true`.
- `web_redirect_uris`: The redirect URIs for web applications. Default is an empty list.
- `group_membership_claims`: The group membership claims contained in the token. Default is `["None"]`.
- `sign_in_audience`: The sign-in audience of the app. Default is `"AzureADMyOrg"`.
- `known_client_applications`: The App IDs of known client applications. Default is an empty list.
- `access_token_version`: The version of the access token. Default is `1`. Must be `2` when `sign_in_audience` is either `AzureADandPersonalMicrosoftAccount` or `PersonalMicrosoftAccount`
- `public_client_redirect_uris`: The redirect URIs for public clients. Default is an empty list.
- `spa_redirect_uris`: The redirect URIs for single-page applications. Default is an empty list.
- `implicit_grant`: Whether to enable implicit grant flow. Default is
`{ access_token_issuance_enabled = false, id_token_issuance_enabled = false }`.
- `homepage_url`: The homepage URL of the app. Default is `null`.
- `logout_url`: The logout URL of the app. Default is `null`.
- `oauth2_scopes`: The OAuth2 scopes defined by the API. Default is an empty map.
- `app_roles`: The App roles defined by the API. Default is an empty map.
- `api_access`: Define which APIs this app needs to access with which scopes and/or roles. Default is an empty map.
- `rbac_assignments`: Map of Azure Resources to Role assignments for this Service Principal. Default is an empty map.
- `define_optional_claims`: Whether to use optional claims. Default is `false`.
- `access_token_claims`: The optional claims to include in the access token. Default is an empty map.
- `id_token_claims`: The optional claims to include in the id token. Default is an empty map.
- `saml2_token_claims`: The optional claims to include in the saml2 token. Default is an empty map.

### Example with Optional Variables

```hcl
module "sample_app" {
  source = "github.com/drpfleger/terraform/service-app"

  subscription_id        = "project-subscription-id"
  project                = "escorial-id"
  environment            = "main"
  app_type               = "sample-app"
  description            = "This is a sample service app"
  is_confidential_client = true
  use_password           = true
  use_certificate        = false

  password_rotation_days    = 90
  enabled_for_sign_in       = true
  assignment_required       = false
  web_redirect_uris         = ["https://example.com/callback"]
  group_membership_claims   = ["SecurityGroup"]
  sign_in_audience          = "AzureADMyOrg"
  known_client_applications = ["client-app-id"]
  access_token_version      = 2
  
  homepage_url  = "https://example.com"
  logout_url    = "https://example.com/logout"
  # e.g. define two scopes, one user one admin
  oauth2_scopes = {
    "full" = {
      admin_consent_description  = "Allow the application full access to the API on behalf of the signed-in user."
      admin_consent_display_name = "Full access"
      scope_type                 = "User"
      scope_value                = "full"
      user_consent_description   = "Access all Methods of the API on your behalf"
      user_consent_display_name  = "Full access"
    }
    "admin" = {
      admin_consent_description  = "Allow the application admin access to the API on behalf of the signed-in user."
      admin_consent_display_name = "Admin access"
      scope_type                 = "Admin"
      scope_value                = "admin"
      user_consent_description   = "Access admin Methods of the API on your behalf"
      user_consent_display_name  = "Admin access"
    }
  }
  app_roles = {
    "userRole" = {
      allowed_member_types = ["User"]
      display_name         = "Sample User Role"
      description          = "Default Sample Role for Users"
      value                = "sampleUserRole"
    }
  }

  # Example: Give this app permissions to access Graph API with scope/role.
  # Assign (user delegated) scope User.Read and (application) role User.Read.All
  # use api_roles for application permissions and api_scopes for delegated permissions
  # e.g. for Graph API permissions can be looked up here:
  # use the scope/role name to look up the id automatically
  # https://learn.microsoft.com/en-us/graph/permissions-reference
  api_access = {
    graph = {
      api_client_id = "00000003-0000-0000-c000-000000000000"
      api_roles     = ["User.Read.All"]
      api_scopes    = ["User.Read"]
    }
  }

  # You can assign RBAC roles to the SP associated with this application.
  # Scope_id needs to be the resource id for which this Role is assigned
  # Role is the display name of the Role as seen in Azure portal
  # To use IDs as scope from a different module defined in the same main.tf file
  # it makes sense to output the id from the other module and pass it here. 
  rbac_assignments = {
    "assignment1" = {
      scope_id             = module.<module_name>.<output_name>
      role_definition_name = "<role-definition-name>"
    }
  }
}
```