module "aio_infra" {
  count = var.should_bootstrap_aio ? 1 : 0

  source = "github.com/azure-samples/azure-edge-extensions-aio-iac-terraform//deploy/modules/infra?ref=main"

  name     = var.name
  location = var.location

  vm_computer_name    = var.vm_computer_name
  vm_username         = var.vm_username
  vm_ssh_pub_key_file = var.vm_ssh_pub_key_file
}

module "aio_full" {
  count = var.should_bootstrap_aio ? 1 : 0

  source = "github.com/azure-samples/azure-edge-extensions-aio-iac-terraform//deploy/modules/aio-full?ref=main"

  name     = var.name
  location = var.location

  depends_on = [module.aio_infra]
}

module "opc_plc_sim" {
  count = var.should_bootstrap_aio ? 1 : 0

  source = "github.com/azure-samples/azure-edge-extensions-aio-iac-terraform//deploy/modules/opc-plc-sim?ref=main"

  name     = var.name
  location = var.location

  depends_on = [module.aio_full]
}
