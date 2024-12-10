locals {
  # Predefined tags
  required_tags = {
    project     = var.project
    environment = var.environment,
    terraform   = "yes"
  }
}
