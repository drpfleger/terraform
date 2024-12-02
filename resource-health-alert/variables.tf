variable "subscription_id" {
  description = "The Azure Subscription ID where the resources will be deployed"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.subscription_id))
    error_message = "Must be a valid subscription id"
  }
}

variable "project" {
  description = "The name of the project for which the resources are being created"
  type        = string
}

variable "resource_types" {
  description = "A list of resource types that need to be monitored for health status"
  type        = list(string)
  default     = null
}

variable "environment" {
  description = "The deployment environment or stage (e.g., dev, sbx, tst, prd)"
  type        = string

  validation {
    condition     = var.environment == "dev" || var.environment == "prd" || var.environment == "sbx" || var.environment == "tst"
    error_message = "Must be dev, sbx, tst or prd"
  }
}

variable "action_group_id" {
  description = "The ID of the Action Group to be used for alert notifications"
  type        = string
}

variable "enable_health_alert" {
  description = "A boolean flag to enable or disable health alerts for the monitored resources"
  type        = bool
  default     = true
}
