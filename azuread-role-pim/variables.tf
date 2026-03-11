variable "configuration_name" {
  description = "Name of this PIM configuration. Used to build the group name with schema SGU_PIM_{privilege_level}Priv_{configuration_name}."
  type        = string
}

variable "roles" {
  description = "List of directory roles to be assigned to this privileged group."
  type        = list(string)
}

variable "active_members" {
  description = "List of User UPNs that are directly assigned as active members of the privileged group."
  type        = list(string)
}

variable "eligible_members" {
  description = "List of User UPNs that are eligible to activate membership in the privileged group for a limited time."
  type        = list(string)
}

variable "approver_members" {
  description = "List of User UPNs that are allowed to approve activation requests for eligible members."
  type        = list(string)
  default     = []
}

variable "privilege_level" {
  description = "The privilege level of the group."
  type        = string
  validation {
    condition     = contains(["Low", "Med", "High"], var.privilege_level)
    error_message = "The privilege_level must be one of: Low, Med, High."
  }
}

variable "additional_group_membership" {
  description = "List of additional group names to add the privileged group to as a member."
  type        = list(string)
  default     = []
}

# Policy settings, set restrictive defaults, can be overridden for lower privilege levels
variable "max_activation_duration" {
  description = "Maximum duration for PIM member activation."
  type        = string
  default     = "PT2H"
}

variable "require_approval" {
  description = "Whether to require approval for PIM member activation."
  type        = bool
  default     = true
}

variable "require_mfa" {
  description = "Whether to require MFA for PIM member activation."
  type        = bool
  default     = true
}

variable "require_justification" {
  description = "Whether to require justification for PIM member activation."
  type        = bool
  default     = true
}

variable "use_notification_default_recipients" {
  description = "Whether to send PIM notifications to default recipients."
  type        = bool
  default     = true
}

variable "notification_additional_recipients" {
  description = "List of additional email addresses to send PIM notifications to."
  type        = list(string)
  default     = []
}

variable "send_admin_notifications" {
  description = "Whether to send admin notifications for PIM assignments."
  type        = bool
  default     = true
}

variable "send_assignee_notifications" {
  description = "Whether to send assignee notifications for PIM assignments."
  type        = bool
  default     = true
}

variable "send_approver_notifications" {
  description = "Whether to send approver notifications for PIM assignments. Must be true if require_approval is true, otherwise it will be ignored."
  type        = bool
  default     = true

  validation {
    condition     = !var.require_approval || var.send_approver_notifications
    error_message = "send_approver_notifications must be true when require_approval is true."
  }
}
