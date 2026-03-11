# Group containing eligible users, not role assignable
resource "azuread_group" "pim_eligible_group" {
  display_name            = "${var.admin_group_name}-eligible"
  security_enabled        = true
  prevent_duplicate_names = true
  members                 = local.object_ids_eligible
}
