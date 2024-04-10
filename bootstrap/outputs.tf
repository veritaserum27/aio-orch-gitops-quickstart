resource "local_sensitive_file" "backend" {
  filename = "../out/quickstart.tfbackend"
  content  = <<-BACKEND
    resource_group_name   = "${azurerm_resource_group.this.name}"
    storage_account_name  = "${azurerm_storage_account.tfstate.name}"
    container_name        = "${azurerm_storage_container.tfstate.name}"
    key                   = "quickstart.terraform.tfstate"
    
    client_id       = "${azuread_service_principal.aio_gitops.client_id}"
    client_secret   = "${azuread_application_password.aio_gitops.value}"
    subscription_id = "${data.azurerm_client_config.current.subscription_id}"
    tenant_id       = "${data.azurerm_client_config.current.tenant_id}"
  BACKEND
}