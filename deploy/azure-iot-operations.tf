module "aio_full" {
  source = "github.com/azure-samples/azure-edge-extensions-aio-iac-terraform//deploy/modules/aio-full?ref=main"

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
}
