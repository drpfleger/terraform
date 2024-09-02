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

variable "log_analytics_name" {
  description = "Name of the log analytics workspace"
  type        = string
}

variable "log_analytics_subscription" {
  description = "Subscription id of the log analytics workspace"
  type        = string
}

variable "log_analytics_resource_group" {
  description = "Resource group of the log analytics workspace"
  type        = string
}

variable "subscription_id" {
  description = "Subscription Id"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.subscription_id))
    error_message = "Must be a valid subscription id"
  }
}

locals {

  # If a resource should be created can be defined with count property that requires an number value
  set_diagnostic_settings = var.use_diagnostic_settings == true ? 1 : 0

  # Predefined tags
  required_tags = {
    project     = var.project
    environment = var.environment,
    terraform   = "yes"
  }
}
