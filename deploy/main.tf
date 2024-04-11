locals {
  custom_locations_id = "${data.azurerm_resource_group.this.id}/providers/Microsoft.ExtendedLocation/customLocations/cl-${var.name}-aio"
}

data "azurerm_resource_group" "this" {
  name = coalesce(var.resource_group_name, "rg-${var.name}")
}
