terraform {
  required_version = ">= 1.6.4"
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = ">= 1.12.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.93.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.45.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.5"
    }
    local = {
      source = "hashicorp/local"
    }
    http = {
      source = "hashicorp/http"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}