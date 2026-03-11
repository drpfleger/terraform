variable "admin_group_name" {
  description = "Name of the admin group for which PIM should be enabled."
  type        = string
}

variable "active_members" {
  description = "List of User UPNs that are directly assigned as active members of the privileged group."
  type        = list(string)
  default     = []
}

variable "eligible_members" {
  description = "List of User UPNs that are eligible to activate membership in the privileged group for a limited time."
  type        = list(string)
  default     = []
}

# Policy settings, set restrictive defaults, can be overridden for lower privilege levels
variable "max_activation_duration" {
  description = "Maximum duration for PIM member activation."
  type        = string
  default     = "PT10H"
}

variable "require_approval" {
  description = "Whether to require approval for PIM member activation."
  type        = bool
  default     = false
}

variable "require_mfa" {
  description = "Whether to require MFA for PIM member activation."
  type        = bool
  default     = true
}

variable "require_justification" {
  description = "Whether to require justification for PIM member activation."
  type        = bool
  default     = false
}
