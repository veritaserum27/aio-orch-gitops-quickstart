locals {
  admin_object_id = data.azurerm_client_config.current.object_id
}

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "this" {
  name     = coalesce(var.resource_group_name, "rg-${var.name}")
  location = var.location
}

resource "azurerm_storage_account" "tfstate" {
  name                     = var.storage_account_name != null ? var.storage_account_name : "sa${replace(var.name, "-", "")}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = var.location
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

