locals {
  resource_group_id = data.azurerm_resource_group.this.id

  admin_object_id = data.azurerm_client_config.current.object_id
}

data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "this" {
  name = var.should_bootstrap_aio ? module.aio_infra[0].resource_group_name : (
    var.resource_group_name != null ? var.resource_group_name : "rg-${var.name}"
  )
  depends_on = [module.aio_infra]
}

resource "azurerm_storage_account" "tfstate" {
  name                     = var.storage_account_name != null ? var.storage_account_name : "sa${replace(var.name, "-", "")}"
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = data.azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  identity {
    type = "SystemAssigned"
  }

  shared_access_key_enabled       = true
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

