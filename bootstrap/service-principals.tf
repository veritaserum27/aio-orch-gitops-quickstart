// GitOps Service Principal for this repo which will have Owner access on the Resource Group

resource "azuread_application" "aio_gitops" {
  display_name = "sp-${var.name}-gitops"
  owners       = [local.admin_object_id]
}

resource "azuread_application_password" "aio_gitops" {
  display_name      = "rbac"
  application_id    = "/applications/${azuread_application.aio_gitops.object_id}"
  end_date_relative = "4383h" // valid for 6 months then must be rotated for continued use.
}

resource "azuread_service_principal" "aio_gitops" {
  client_id       = azuread_application.aio_gitops.client_id
  account_enabled = true
  owners          = [local.admin_object_id]
}