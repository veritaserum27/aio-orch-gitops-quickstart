resource "azurerm_role_assignment" "aio_gitops" {
  scope        = data.azurerm_resource_group.this.id
  principal_id = azuread_service_principal.aio_gitops.id

  role_definition_name = "Owner"
}