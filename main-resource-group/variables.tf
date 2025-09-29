variable "main_resource_group_name" {
  description = "Name of the central resource group"
  type        = string
}

variable "location" {
  description = "azure resource location"
  type        = string
  default     = "westeurope"
}

variable "project" {
  description = "the project name"
  type        = string
}

variable "environment" {
  description = "Environment/Stage"
  type        = string

  validation {
    condition     = var.environment == "dev" || var.environment == "prd" || var.environment == "sbx" || var.environment == "tst" || var.environment == "main"
    error_message = "Must be dev, sbx, tst, main or prd"
  }
}

variable "use_diagnostic_settings" {
  description = "True, when the diagnostic settings must be created"
  type        = bool
  default     = false
}

variable "keyvault_purge_protection" {
  description = "Enable or disable purge protection for the key vault"
  type        = bool
  default     = false
}

variable "keyvault_enabled_for_template_deployment" {
  description = "Enable or disable template deployment for the key vault"
  type        = bool
  default     = true
}

variable "keyvault_enabled_for_disk_encryption" {
  description = "Enable or disable disk encryption for the key vault"
  type        = bool
  default     = false
}

variable "keyvault_enabled_for_deployment" {
  description = "Enable or disable deployment for the key vault"
  type        = bool
  default     = true
}
variable "keyvault_enable_rbac_authorization" {
  description = "Enable or disable RBAC authorization for the key vault"
  type        = bool
  default     = true
}
variable "keyvault_public_network_access_enabled" {
  description = "Enable or disable public network access for the key vault"
  type        = bool
  default     = true
}

variable "keyvault_sku_name" {
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium"
  type        = string
  default     = "standard"
}

variable "keyvault_prevent_destroy_enabled" {
  description = "Enable or disable prevent_destroy lifecycle on the key vault. When set to false, allows the key vault to be destroyed"
  type        = bool
  default     = true
}

variable "log_analytics_name" {
  description = "Name of the log analytics workspace"
  type        = string
  default     = null

  validation {
    condition     = var.use_diagnostic_settings == false || (var.use_diagnostic_settings == true && var.log_analytics_name != null)
    error_message = "log_analytics_name is mandatory if use_diagnostic_settings is set to true"
  }
}

variable "log_analytics_subscription" {
  description = "Subscription id of the log analytics workspace"
  type        = string
  default     = null

  validation {
    condition     = var.use_diagnostic_settings == false || (var.use_diagnostic_settings == true && var.log_analytics_subscription != null)
    error_message = "log_analytics_subscription is mandatory if use_diagnostic_settings is set to true"
  }
}

variable "log_analytics_resource_group" {
  description = "Resource group of the log analytics workspace"
  type        = string
  default     = null

  validation {
    condition     = var.use_diagnostic_settings == false || (var.use_diagnostic_settings == true && var.log_analytics_resource_group != null)
    error_message = "log_analytics_resource_group is mandatory if use_diagnostic_settings is set to true"
  }
}

variable "subscription_id" {
  description = "Subscription Id"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.subscription_id))
    error_message = "Must be a valid subscription id"
  }
}

variable "group_assignable_to_role" {
  description = "True, when the EntraId group is assignable to a role"
  type        = bool
  default     = false
}

variable "admin_group_role" {
  description = "The role name that should be assigned to the created admin group on subscription level"
  type        = string
  default     = "Owner"
}

variable "override_keyvault_name" {
  description = "Override the key vault name"
  type        = string
  default     = null
}

# Budget and Action Group variables
variable "enable_budget" {
  description = "Enable budget monitoring for the subscription"
  type        = bool
  default     = false
}

variable "budget_amount" {
  description = "The budget amount in currency units. Required if enable_budget is true"
  type        = number
  default     = null

  validation {
    condition     = var.enable_budget == false || (var.enable_budget == true && var.budget_amount != null && var.budget_amount > 0)
    error_message = "budget_amount must be a positive number when enable_budget is true"
  }
}

variable "budget_forecast_threshold" {
  description = "The budget forecast threshold percentage that triggers a notification"
  type        = number
  default     = 80

  validation {
    condition     = var.budget_forecast_threshold > 0 && var.budget_forecast_threshold <= 100
    error_message = "budget_forecast_threshold must be between 1 and 100"
  }
}

variable "budget_actual_threshold" {
  description = "The budget actual threshold percentage that triggers a notification"
  type        = number
  default     = 100

  validation {
    condition     = var.budget_actual_threshold > 0 && var.budget_actual_threshold <= 100
    error_message = "budget_actual_threshold must be between 1 and 100"
  }
}

variable "alert_email_receivers" {
  description = "List of email addresses to receive budget alerts. Required if enable_budget is true"
  type        = list(string)
  default     = []

  validation {
    condition     = var.enable_budget == false || (var.enable_budget == true && length(var.alert_email_receivers) > 0)
    error_message = "alert_email_receivers must contain at least one email address when enable_budget is true"
  }

  validation {
    condition = alltrue([
      for email in var.alert_email_receivers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))
    ])
    error_message = "All email addresses in alert_email_receivers must be valid email addresses"
  }
}

variable "action_group_short_name_override" {
  description = "Override the action group short name (max 12 characters). If not provided, uses project name truncated to 12 chars"
  type        = string
  default     = null

  validation {
    condition     = var.action_group_short_name_override == null || length(var.action_group_short_name_override) <= 12
    error_message = "action_group_short_name_override must be 12 characters or less"
  }
}

# Resource Health Alert variables
variable "enable_resource_health_alert" {
  description = "Enable resource health monitoring and alerts"
  type        = bool
  default     = false
}

variable "health_alert_resource_types" {
  description = "List of resource types to monitor for health status. If not provided, monitors all resource types in the resource group"
  type        = list(string)
  default     = null
}

variable "health_alert_email_receivers" {
  description = "List of email addresses to receive health alerts. Used when enable_resource_health_alert is true and enable_budget is false"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for email in var.health_alert_email_receivers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))
    ])
    error_message = "All email addresses in health_alert_email_receivers must be valid email addresses"
  }

  validation {
    condition = var.enable_resource_health_alert == false || (
      var.enable_resource_health_alert == true && (
        var.enable_budget == true || length(var.health_alert_email_receivers) > 0
      )
    )
    error_message = "When enable_resource_health_alert is true, either enable_budget must be true OR health_alert_email_receivers must contain at least one email address"
  }
}
