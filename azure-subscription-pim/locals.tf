locals {
  # List of eligible members' object IDs
  object_ids_eligible = [
    for upn in var.eligible_members : data.azuread_user.pim_members[upn].object_id
  ]
}
