terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }
}

# Configure the Microsoft Azure Provider
variable arm_subscription_id {}
variable arm_tenant_id {} 
variable arm_client_id {}
variable arm_secret {}



provider "azurerm" {
  features {}

  # More information on the authentication methods supported by
  # the AzureRM Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

  subscription_id = var.arm_subscription_id
  tenant_id       = var.arm_tenant_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_secret
}

terraform {
  backend "azurerm" {
    resource_group_name  = "tf_rg_blobstore_tf.file"
    storage_account_name = "storageaccounttfsta"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Create a resource group
resource "azurerm_resource_group" "tf_test" {
  name     = "test-resources"
  location = "West Europe"
}

# Create a virtual network in the production-resources resource group
/*resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
} */

resource "azurerm_container_group" "tf_container_test" {
  name = "wheatherapi"
  location =  azurerm_resource_group.tf_test.location
  resource_group_name = azurerm_resource_group.tf_test.name
  ip_address_type = "public"
  dns_name_label      = "aplicatieAPI"
  os_type             = "Linux"

  container {
    name   = "whaterapi"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "1"
    memory = "1"

  ports {
      port     = 80
      protocol = "TCP"
    }
  }

}