# This defines the group policy for the high-privileged groups managed by this module.
# The policy is activated for the role "member" and requires approval, justification and multi-factor authentication.
# Since no eligible or active assignments for the role 'owner' of the pim groups are defined, policies for role 'owner' are not defined.
resource "azuread_group_role_management_policy" "pim_member_policy" {
  group_id = data.azuread_group.pim_privileged_group.object_id
  role_id  = "member"

  activation_rules {
    maximum_duration                   = var.max_activation_duration
    require_approval                   = var.require_approval
    require_justification              = var.require_justification
    require_multifactor_authentication = var.require_mfa

    # always set members of the eligible group as activation approvers
    approval_stage {
      primary_approver {
        object_id = azuread_group.pim_eligible_group.object_id
        type      = "groupMembers"
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
        default_recipients = true
        notification_level = "Critical"
      }
      assignee_notifications {
        default_recipients = true
        notification_level = "All"
      }
      approver_notifications {
        default_recipients = true
        notification_level = "All"
      }
    }
    active_assignments {
      admin_notifications {
        default_recipients = true
        notification_level = "Critical"
      }
      assignee_notifications {
        default_recipients = true
        notification_level = "All"
      }
      approver_notifications {
        default_recipients = true
        notification_level = "All"
      }
    }
    eligible_activations {
      admin_notifications {
        default_recipients = true
        notification_level = "Critical"
      }
      assignee_notifications {
        default_recipients = true
        notification_level = "All"
      }
      approver_notifications {
        default_recipients = true
        notification_level = "All"
      }
    }
  }
}
