output "resource_health_alert_id" {
  description = "ID of the ResourceHealth activity log alert"
  value       = try(azurerm_monitor_activity_log_alert.default_health_status[0].id, null)
}

output "resource_health_alert_name" {
  description = "Name of the ResourceHealth activity log alert"
  value       = try(azurerm_monitor_activity_log_alert.default_health_status[0].name, null)
}

output "service_health_alert_id" {
  description = "ID of the ServiceHealth activity log alert"
  value       = try(azurerm_monitor_activity_log_alert.default_service_health_status[0].id, null)
}

output "service_health_alert_name" {
  description = "Name of the ServiceHealth activity log alert"
  value       = try(azurerm_monitor_activity_log_alert.default_service_health_status[0].name, null)
}
