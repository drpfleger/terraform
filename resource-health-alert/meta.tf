data "azurerm_resources" "all" {
  resource_group_name = local.resource_group_name
}

data "azurerm_resource_group" "main" {
  name = local.resource_group_name
}

locals {
  resource_types = distinct([for resource in data.azurerm_resources.all.resources : resource.type])
}
