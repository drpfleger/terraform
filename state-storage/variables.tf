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
  default     = "zombie"
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
