terraform {
  required_version = ">= 1.6.0"

  backend "azurerm" {
    resource_group_name  = "ausmart-tfstate-rg"
    storage_account_name = "ausmarttfstatedev"
    container_name       = "tfstate"
    key                  = "au-dev.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
