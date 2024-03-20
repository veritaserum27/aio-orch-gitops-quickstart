# Azure IoT Operations Orchestrator CD Quickstart

Quickstart on Azure IoT Operations (AIO) for deploying with Azure IoT Operations Orchestrator using GitHub Actions.

This project leverages the following repos:

- [Azure-Samples/azure-edge-extensions-aio-iac-terraform](https://github.com/Azure-Samples/azure-edge-extensions-aio-iac-terraform)
- [Azure-Samples/azure-edge-extensions-aio-datahistorian](https://github.com/Azure-Samples/azure-edge-extensions-aio-datahistorian)

For more information on *azure-edge-extensions* please refer to [Azure-Samples/azure-edge-extensions](https://github.com/Azure-Samples/azure-edge-extensions).

## Getting Started

Refer to the [Azure-Samples/azure-edge-extensions-aio-iac-terraform Getting Started section](https://github.com/Azure-Samples/azure-edge-extensions-aio-iac-terraform?tab=readme-ov-file#getting-started) for **prerequisite requirements** and instructions on registering the **required providers**. 

Bootstrap will leverage azure-edge-extensions-aio-iac-terraform as modules to deploy a VM with k3s and AIO.

## Bootstrap

Bootstrap will be ran from an admin's machine or environment and it will create the necessary resources in order to allow for a GitHub operated CD with Terraform.

Bootstrapping your environment will setup the following components:

- Azure Resource Group.
- Azure VM with k3s installed.
- Azure IoT Operations.
- OPC PLC Simulator deployed on Azure IoT Operations.
- Service Principal with Owner access to the new Resource Group to be used by GitHub Actions.
- Azure Storage Account and Container for Terraform state.

Complete the following commands in order to bootstrap your environment:

1. Generate a new ssh key to use with the new VM (replace the `<computer-username>` with the username that will be used for the VM):
    ```shell
    ssh-keygen -t rsa -b 4096 -C "<computer-username>" -f ~/.ssh/id_aio_rsa
    # Press enter twice unless you want a passphrase
    ```
2. Login to the AZ CLI:
    ```shell
    az login --tenant <tenant>.onmicrosoft.com
    ```
    - Make sure your subscription is the one that you would like to use: `az account show`.
    - Change to the subscription that you would like to use if needed:
      ```shell
      az account set -s <subscription-id>
      ```
3. Add a `<unique-name>.auto.tfvars` file to the root of the [bootstrap](bootstrap) directory that contains the following (refer to [bootstrap/sample.auto.tfvars.example](bootstrap/sample.auto.tfvars.example) for an example):
    ```hcl
    // <project-root>/deploy/root-<unique-name>.tfvars

    name = "<unique-name>"
    location = "<location>"
    ```
4. From the [bootstrap](bootstrap) directory execute the following:
   ```shell
   terraform init
   terraform apply -auto-approve
   ```
   
Deploying and bootstrapping the entire environment will take some time (approximately 25 minutes since last time ran).

The result should be an environment deployed into a new Resource Group with a new [out/quickstart.tfbackend](out/quickstart.tfbackend) file created. This file will be used for later steps.