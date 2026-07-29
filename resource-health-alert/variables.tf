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
  description = "A list of resource types that need to be monitored for resource health status"
  type        = list(string)
  default     = null
}

variable "resource_ids" {
  description = "Optional ARM resource IDs used to derive ResourceHealth resource types when resource_types is not provided"
  type        = list(string)
  default     = null

  validation {
    condition = var.resource_ids == null || alltrue([
      for resource_id in var.resource_ids : can(regex("(?i)^/subscriptions/[^/]+/.*/providers/[^/]+/.+$", trimspace(resource_id)))
    ])
    error_message = "Each entry in resource_ids must be a valid ARM resource ID"
  }
}

variable "create_resource_health_alert" {
  description = "Whether to create the ResourceHealth activity log alert"
  type        = bool
  default     = true
}

variable "environment" {
  description = "The deployment environment or stage (e.g., dev, sbx, tst, prd)"
  type        = string
}

variable "action_group_id" {
  description = "The ID of the Action Group to be used for alert notifications"
  type        = string
}

variable "enable_health_alert" {
  description = "A boolean flag to enable or disable the ResourceHealth alert if it is created"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "The name of the resource group where the alert resources will be deployed"
  type        = string
}

variable "resource_health_scope_mode" {
  description = "Filter mode for ResourceHealth criteria. subscription monitors all resources in the same subscription, resource_group filters by resource_group_name, resource_groups filters by monitored_resource_groups"
  type        = string
  default     = "subscription"

  validation {
    condition     = contains(["subscription", "resource_group", "resource_groups"], var.resource_health_scope_mode)
    error_message = "resource_health_scope_mode must be one of: subscription, resource_group, resource_groups"
  }

  validation {
    condition     = var.resource_health_scope_mode != "resource_groups" || (var.monitored_resource_groups != null && length(var.monitored_resource_groups) > 0)
    error_message = "monitored_resource_groups must contain at least one entry when resource_health_scope_mode is resource_groups"
  }
}

variable "monitored_resource_groups" {
  description = "Optional list of resource group names to monitor when resource_health_scope_mode is resource_groups"
  type        = list(string)
  default     = null

  validation {
    condition = var.monitored_resource_groups == null || alltrue([
      for resource_group in var.monitored_resource_groups : trimspace(resource_group) != ""
    ])
    error_message = "monitored_resource_groups cannot contain empty resource group names"
  }
}

variable "enable_service_health_alert" {
  description = "Whether to create the ServiceHealth activity log alert"
  type        = bool
  default     = false
}

variable "service_health_events" {
  description = "Service Health event types to monitor"
  type        = list(string)
  default     = ["Incident", "Maintenance", "ActionRequired", "Security"]

  validation {
    condition = alltrue([
      for event in var.service_health_events : contains(["Incident", "Maintenance", "Informational", "ActionRequired", "Security"], event)
    ])
    error_message = "service_health_events can only contain: Incident, Maintenance, Informational, ActionRequired, Security"
  }

  validation {
    condition     = length(var.service_health_events) > 0
    error_message = "service_health_events must contain at least one event"
  }
}

variable "service_health_services" {
  description = "Optional list of Azure service names to monitor for Service Health"
  type        = list(string)
  default     = null

  validation {
    condition = var.service_health_services == null || alltrue([
      for service in var.service_health_services : trimspace(service) != ""
    ])
    error_message = "service_health_services cannot contain empty service names"
  }
}

variable "service_health_locations" {
  description = "Optional list of Azure regions to monitor for Service Health"
  type        = list(string)
  default     = null

  validation {
    condition = var.service_health_locations == null || alltrue([
      for location in var.service_health_locations : trimspace(location) != ""
    ])
    error_message = "service_health_locations cannot contain empty location names"
  }
}
