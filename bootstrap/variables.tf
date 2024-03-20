variable "name" {
  description = "The unique primary name used when naming resources. (ex. 'test' makes 'rg-test' resource group)"
  type        = string
  nullable    = false
  validation {
    condition     = var.name != "sample-aio" && length(var.name) < 15 && can(regex("^[a-z0-9][a-z0-9-]{1,60}[a-z0-9]$", var.name))
    error_message = "Please update 'name' to a short, unique name, that only has lowercase letters, numbers, '-' hyphens."
  }
}

variable "location" {
  type    = string
  default = "westus3"
}

variable "should_bootstrap_aio" {
  description = "(Optional) Should create a new Azure Linux VM and install k3s and AIO. (Otherwise, 'true' if set to false then a Resource Group with AIO should already exist)"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "(Optional) The name of the Resource Group. (Otherwise, 'rg-<name>' if not bootstrapping aio or module.aio_infra.resource_group_name)"
  type        = string
  default     = null
}

variable "storage_account_name" {
  description = "(Optional) The name of the Storage Account. (Otherwise, 'sa<var.name>' with '-' removed)"
  type        = string
  default     = null
}

variable "vm_computer_name" {
  description = "The Computer Name for the VM."
  type        = string
  nullable    = false
}

variable "vm_username" {
  description = "The Username used to login to the VM."
  type        = string
  nullable    = false
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,60}[a-z0-9]$", var.vm_username))
    error_message = "Please update 'vm_username' which only has lowercase letters, numbers, '-' hyphens."
  }
}

variable "vm_ssh_pub_key_file" {
  description = "(Required for Linux VMs) The file path to the SSH public key."
  type        = string
  default     = null
}
