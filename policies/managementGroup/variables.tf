variable "definition_management_group" {
  description = "Name (group_id) of the management group the policy is available to (get inherited by child management groups)."
  type        = string
}

variable "assignment_management_groups" {
  description = "List of names (group_id) of the management groups to assign policies to."
  type        = list(string)
}

variable "policy_name" {
  description = "Name of the policy definition"
  type        = string
}

variable "policy_display_name" {
  description = "Display name of the policy definition"
  type        = string
}

variable "policy_mode" {
  description = "All, Indexed. Indexed: Policy is enforced only on resources that support the required properties. All: Policy is enforced on all resources."
  type        = string

  validation {
    condition = contains([
      "All",
      "Indexed",
      "Microsoft.ContainerService.Data",
      "Microsoft.CustomerLockbox.Data",
      "Microsoft.DataCatalog.Data",
      "Microsoft.KeyVault.Data",
      "Microsoft.Kubernetes.Data",
      "Microsoft.MachineLearningServices.Data",
      "Microsoft.Network.Data",
      "Microsoft.Synapse.Data"
    ], var.policy_mode)
    error_message = "policy_mode must be one of: All, Indexed, Microsoft.ContainerService.Data, Microsoft.CustomerLockbox.Data, Microsoft.DataCatalog.Data, Microsoft.KeyVault.Data, Microsoft.Kubernetes.Data, Microsoft.MachineLearningServices.Data, Microsoft.Network.Data, Microsoft.Synapse.Data."
  }
}

variable "policy_rule" {
  description = "Policy rule in JSON format as a string. Must follow Azure Policy JSON schema."
  type        = any
}

variable "assignment_name" {
  description = "Name of the policy assignment"
  type        = string
}

variable "meta_data" {
  description = "Metadata for the policy definition in JSON format as a string."
  type        = any
  default     = null
}
