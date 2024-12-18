variable "target_resource_id" {
  description = "Id of the resource to implement diagnostic settings"
  type        = string
}

variable "enabled" {
  description = "value to enable or disable the diagnostic settings"
  type        = bool
  default     = true
}

variable "log_analytics_resource_group" {
  description = "Resource group of the log analytics workspace"
  type        = string
}

variable "log_analytics_name" {
  description = "Name of the log analytics workspace"
  type        = string
}

variable "diagnostic_name" {
  description = "Name of the diagnostic settings"
  type        = string
  default     = "diag-default"
}

variable "destination_type" {
  description = "Default is AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables."
  type        = string
  default     = "Skip"
  validation {
    condition     = var.destination_type == "AzureDiagnostics" || var.destination_type == "Dedicated" || var.destination_type == "Skip"
    error_message = "Must be AzureDiagnostics or Dedicated. If Skip is used, the destination will not be set."
  }
}

variable "user_defined_category_groups" {
  description = "List of user defined categories to be sent to log analytics"
  type        = list(string)
  default     = null
}

variable "user_defined_categories" {
  description = "List of user defined categories to be sent to log analytics"
  type        = list(string)
  default     = null

  validation {
    condition = (
      length(coalesce(var.user_defined_categories, [])) == 0 ||
      length(coalesce(var.user_defined_category_groups, [])) == 0
    )
    error_message = "Only one of user_defined_categories or user_defined_category_groups can be set."
  }
}

variable "user_defined_metrics" {
  description = "List of user defined metrics to be sent to log analytics"
  type        = list(string)
  default     = null
}
