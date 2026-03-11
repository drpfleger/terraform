locals {
  # List of eligible members' object IDs
  object_ids_eligible = [
    for upn in var.eligible_members : data.azuread_user.pim_members[upn].object_id
  ]

  object_ids_approvers = [
    for upn in var.approver_members : data.azuread_user.pim_approvers[upn].object_id
  ]

  send_approver_notifications = var.require_approval && var.send_approver_notifications
}
