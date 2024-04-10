module "aio_full" {
  source = "github.com/azure-samples/azure-edge-extensions-aio-iac-terraform//deploy/modules/aio-full?ref=main"

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "opc_plc_sim" {
  source = "github.com/azure-samples/azure-edge-extensions-aio-iac-terraform//deploy/modules/opc-plc-sim?ref=main"

  depends_on = [
    module.aio_full
  ]

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
}