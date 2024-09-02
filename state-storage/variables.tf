variable "resource_group_name" {
  description = "Name of the resource group"
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
    condition     = var.environment == "dev" || var.environment == "prd" || var.environment == "sbx" || var.environment == "tst" || var.environment == "nw" || var.environment == "main"
    error_message = "Must be dev, sbx, tst or prd, main or nw for network watcher"
  }
}

variable "use_diagnostic_settings" {
  description = "true, when the diagnostic settings must be created, else false"
  type        = bool
  default     = false
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
