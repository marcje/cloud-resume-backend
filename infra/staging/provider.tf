terraform {
  required_version = ">=1.9, <2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.15.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "mtb-s-cv-backend-tfstate-rg"
    storage_account_name = "mtbscvbackendtfstatest"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

