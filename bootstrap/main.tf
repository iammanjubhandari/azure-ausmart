terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
  }
}

provider "azurerm" {
  features {}
}

variable "location" { default = "australiaeast" }

resource "azurerm_resource_group" "tfstate" {
  name     = "ausmart-tfstate-rg"
  location = var.location
}
