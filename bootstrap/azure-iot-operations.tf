module "aio_infra" {
  count = var.should_bootstrap_aio ? 1 : 0

  source = "github.com/azure-samples/azure-edge-extensions-aio-iac-terraform//deploy/modules/infra?ref=main"

  depends_on = [
    azurerm_resource_group.this
  ]

  name                = var.name
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location

  vm_computer_name    = var.vm_computer_name
  vm_username         = var.vm_username
  vm_ssh_pub_key_file = var.vm_ssh_pub_key_file
  vm_size             = "Standard_D4_v5"

  should_create_resource_group  = false
  should_create_azure_key_vault = true
}
