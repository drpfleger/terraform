variable "management_group_id" {
  description = "ID of the management group to assign policies to"
  type        = string
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
  description = "Policy rule in JSON format (object or string, but typically object)"
  type        = any
}

variable "policy_meta_data" {
  description = "Policy metadata in JSON format (object or string, but typically object)"
  type        = any
}

variable "assignment_name" {
  description = "Name of the policy assignment"
  type        = string
}
