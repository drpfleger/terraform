variable "target_resource_id" {
  description = "Id of the resource to implement diagnostic settings"
  type        = string
}

variable "enabled" {
  description = "value to enable or disable the diagnostic settings"
  type        = bool
}

variable "log_analytics_subscription" {
  description = "Subscription id of the log analytics workspace"
  type        = string
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
  default     = "AzureDiagnostics"
  validation {
    condition     = var.destination_type == "AzureDiagnostics" || var.destination_type == "Dedicated" || var.destination_type == "Skip"
    error_message = "Must be AzureDiagnostics or Dedicated. If Skip is used, the destination will not be set."
  }
}
