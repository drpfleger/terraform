# Blade Certificates and Secrets in Azure portal

# Necessary Setup for password secret
resource "azuread_application_password" "main" {
  count = (var.is_confidential_client && var.use_password) ? 1 : 0

  application_id = azuread_application.main.id
  display_name   = local.app_secret_name
  rotate_when_changed = {
    rotation = time_rotating.main[count.index].id
  }
}

# After n days a tf apply will attempt to rotate the application_password. Default is 180 days.
resource "time_rotating" "main" {
  count         = (var.is_confidential_client && var.use_password) ? 1 : 0
  rotation_days = var.password_roatation_days
}

# Write password to key vault, pw rotation creates a new version of this secret
resource "azurerm_key_vault_secret" "main" {
  count        = (var.is_confidential_client && var.use_password) ? 1 : 0
  name         = local.app_secret_name
  key_vault_id = data.azurerm_key_vault.main.id
  value        = azuread_application_password.main[count.index].value
}

# Necessary Setup for certificate secret
resource "azuread_application_certificate" "main" {
  count = (var.is_confidential_client && var.use_certificate) ? 1 : 0

  application_id = azuread_application.main.id
  value          = azurerm_key_vault_certificate.main[count.index].certificate_data_base64
}

# Generate new certificate if required
resource "azurerm_key_vault_certificate" "main" {
  count = (var.is_confidential_client && var.use_certificate) ? 1 : 0

  name         = local.app_secret_name
  key_vault_id = data.azurerm_key_vault.main.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pem-file"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]
      subject            = "CN=${local.app_name}, O=DrPfleger, C=DE"
      validity_in_months = 12
    }
  }
}
