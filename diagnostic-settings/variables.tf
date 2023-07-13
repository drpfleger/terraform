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
