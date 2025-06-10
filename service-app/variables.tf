# Required variables
variable "project" {
  description = "The project name this app belongs to."
  type        = string
}

variable "environment" {
  description = "Environment/Stage"
  type        = string

  validation {
    condition     = var.environment == "dev" || var.environment == "prd" || var.environment == "sbx" || var.environment == "tst" || var.environment == "main"
    error_message = "Must be main, dev, sbx, tst or prd"
  }
}

variable "app_type" {
  description = "The type of the app. This is used to build the display name project-appType-env."
  type        = string
}

variable "description" {
  description = "A descriptive text for this app."
  type        = string
}

variable "is_confidential_client" {
  description = "Whether this client app is confidential."
  type        = bool

  validation {
    condition = (
      var.is_confidential_client ||
      (!var.use_certificate && !var.use_password)
    )
    error_message = "If 'is_confidential_client' is false, both 'use_certificate' and 'use_password' must be false."
  }
}

variable "use_certificate" {
  description = "Whether to use a certificate as secret."
  type        = bool
}

variable "use_password" {
  description = "Whether to use a password as secret."
  type        = bool
}

# Optional variables
variable "key_vault_id" {
  description = "The Resource ID of the key vault where the secrets should be stored. Required when is_confidential_client is true."
  type        = string
  default     = null

  validation {
    condition = (
      !var.is_confidential_client || var.key_vault_id != null
    )
    error_message = "If 'is_confidential_client' is true, key_vault_id cannot be null."
  }
}

variable "password_roatation_days" {
  description = "Days after which a tf apply will autorotate the password."
  type        = number
  default     = 180
}

variable "enabled_for_sign_in" {
  description = "Whether the service principal is enabled for sign in."
  type        = bool
  default     = true
}

variable "assignement_required" {
  description = "Whether an assignment of User/Group is required to use the app. False: Any user in the sign in audience can use the app."
  type        = bool
  default     = true
}

variable "web_redirect_uris" {
  description = "The redirect URIs for web applications."
  type        = list(string)
  default     = []
}

variable "group_membership_claims" {
  description = "The group membership claims contained in the token. Allowed values: None, SecurityGroup, DirectoryRole, All. Default: None"
  type        = list(string)
  default     = ["None"]
}

variable "sign_in_audience" {
  description = "The sign-in audience of the app. Allowed values: AzureADMyOrg, AzureADMultipleOrgs, AzureADandPersonalMicrosoftAccount, PersonalMicrosoftAccount. Default: AzureADMyOrg"
  type        = string
  default     = "AzureADMyOrg"
}

variable "known_client_applications" {
  description = "The App IDs of known client applications."
  type        = list(string)
  default     = []
}

variable "access_token_version" {
  description = "The version of the access token 1 or 2. Default: 1"
  type        = number
  default     = 1
}

variable "public_client_redirect_uris" {
  description = "The redirect URIs for public clients."
  type        = list(string)
  default     = []
}

variable "spa_redirect_uris" {
  description = "The redirect URIs for single page applications."
  type        = list(string)
  default     = []
}

variable "implicit_grant" {
  description = "Whether to enable implicit grant flow. Use with care."
  type = object({
    access_token_issuance_enabled = bool
    id_token_issuance_enabled     = bool
  })
  default = {
    access_token_issuance_enabled = false
    id_token_issuance_enabled     = false
  }
}

variable "homepage_url" {
  description = "The homepage URL of the app."
  type        = string
  default     = null
}

variable "logout_url" {
  description = "The logout URL of the app."
  type        = string
  default     = null
}

variable "oauth2_scopes" {
  description = "The OAuth2 scopes defined by the API. Empty if no Scopes defined."
  type = map(object({
    admin_consent_description  = string
    admin_consent_display_name = string
    scope_type                 = string # Who can consent? "User" or "Admin"
    scope_value                = string # Defined scope, usually of form resource.operation.constraint (e.g. Groups.Read.All)
    user_consent_description   = string
    user_consent_display_name  = string
  }))
  default = {}
}

variable "app_roles" {
  description = "The App roles defined by the API. Empty if no App roles defined."
  type = map(object({
    allowed_member_types = list(string) # any Combination of ["User", "Application"]
    display_name         = string
    description          = string
    value                = string # role name
  }))
  default = {}
}

variable "api_access" {
  description = "Define which APIs this app needs to access with which scopes and/or roles. Empty if no API access defined."
  type = map(object({
    api_client_id = string
    api_roles     = optional(list(string), []) # Role names
    api_scopes    = optional(list(string), []) # Scope names
  }))
  default = {}
}

variable "rbac_assignments" {
  description = "Map of Azure Resources to Role assignments for this Service Principal. Empty if no RBAC roles assigned."
  type = map(object({
    scope_id             = string
    role_definition_name = string
  }))
  default = {}
}

variable "grant_own_api_access" {
  description = "Specify whether this App should be granted API permissions for its own scopes and roles."
  type        = bool
  default     = false
}

variable "group_object_id" {
  description = "The object ID of the group to assign the Owner role to. If provided, rbac_assignments must be empty."
  type        = string
  default     = null

  validation {
    condition     = var.group_object_id == null || length(var.rbac_assignments) == 0
    error_message = "If 'group_object_id' is provided, 'rbac_assignments' must be empty."
  }
}

# The following optional claims are rarely used.
variable "define_optional_claims" {
  description = "Whether to use optional claims."
  type        = bool
  default     = false
}

variable "access_token_claims" {
  description = "The optional claims to include in the access token. Empty if no optional claims defined."
  type = map(object({
    name                  = string
    essential             = bool
    source                = optional(string)
    additional_properties = list(string)
  }))
  default = {}
}

variable "id_token_claims" {
  description = "The optional claims to include in the id token. Empty if no optional claims defined."
  type = map(object({
    name                  = string
    essential             = bool
    source                = optional(string)
    additional_properties = list(string)
  }))
  default = {}
}

variable "saml2_token_claims" {
  description = "The optional claims to include in the saml2 token. Empty if no optional claims defined."
  type = map(object({
    name                  = string
    essential             = bool
    source                = optional(string)
    additional_properties = list(string)
  }))
  default = {}
}
