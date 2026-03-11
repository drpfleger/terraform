# This resource defines the role management policy for high privileged groups managed by this module, using its activation, approval, justification, MFA, and notification settings.
# The policy is activated for the role "member" and requires approval, justification and multi-factor authentication.
# Since no eligible or active assignments for the role 'owner' of the pim groups are defined, policies for role 'owner' are not defined.
resource "azuread_group_role_management_policy" "pim_member_policy" {
  group_id = azuread_group.pim_privileged_group.object_id
  role_id  = "member"

  activation_rules {
    maximum_duration                   = var.max_activation_duration
    require_approval                   = var.require_approval
    require_justification              = var.require_justification
    require_multifactor_authentication = var.require_mfa

    # set members of the eligible group as activation approvers if approval is required
    dynamic "approval_stage" {
      for_each = var.require_approval ? [1] : []
      content {
        primary_approver {
          object_id = length(var.approver_members) > 0 ? azuread_group.pim_approver_group[0].object_id : azuread_group.pim_eligible_group.object_id
          type      = "groupMembers"
        }
      }
    }
  }

  # The group eligible assignment does not expire
  eligible_assignment_rules {
    expiration_required = false
  }

  # The active assignment does not expire, but assignment requires justification
  active_assignment_rules {
    expiration_required   = false
    require_justification = true
  }

  notification_rules {
    eligible_assignments {
      admin_notifications {
        default_recipients    = var.use_notification_default_recipients
        notification_level    = "Critical"
        additional_recipients = var.send_admin_notifications ? var.notification_additional_recipients : []
      }
      assignee_notifications {
        default_recipients    = var.use_notification_default_recipients
        notification_level    = "All"
        additional_recipients = var.send_assignee_notifications ? var.notification_additional_recipients : []
      }
      dynamic "approver_notifications" {
        for_each = var.send_approver_notifications ? [1] : []
        content {
          default_recipients    = var.use_notification_default_recipients
          notification_level    = "All"
          additional_recipients = var.send_approver_notifications ? var.notification_additional_recipients : []
        }
      }
    }
    active_assignments {
      admin_notifications {
        default_recipients    = var.use_notification_default_recipients
        notification_level    = "Critical"
        additional_recipients = var.send_admin_notifications ? var.notification_additional_recipients : []
      }
      assignee_notifications {
        default_recipients    = var.use_notification_default_recipients
        notification_level    = "All"
        additional_recipients = var.send_assignee_notifications ? var.notification_additional_recipients : []
      }
      dynamic "approver_notifications" {
        for_each = var.send_approver_notifications ? [1] : []
        content {
          default_recipients    = var.use_notification_default_recipients
          notification_level    = "All"
          additional_recipients = var.send_approver_notifications ? var.notification_additional_recipients : []
        }
      }
    }
    eligible_activations {
      admin_notifications {
        default_recipients    = var.use_notification_default_recipients
        notification_level    = "Critical"
        additional_recipients = var.send_admin_notifications ? var.notification_additional_recipients : []
      }
      assignee_notifications {
        default_recipients    = var.use_notification_default_recipients
        notification_level    = "All"
        additional_recipients = var.send_assignee_notifications ? var.notification_additional_recipients : []
      }

      dynamic "approver_notifications" {
        for_each = local.send_approver_notifications ? [1] : []
        content {
          default_recipients    = var.use_notification_default_recipients
          notification_level    = "All"
          additional_recipients = var.send_approver_notifications ? var.notification_additional_recipients : []
        }
      }
    }
  }
}
