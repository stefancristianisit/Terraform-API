terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }
}

# Configure the Microsoft Azure Provider
/*variable "arm_subscription_id" {}
variable arm_tenant_id {} 
variable arm_client_id {} */
/*variable client_secret {} */

provider "azurerm" {
  features {}

  # More information on the authentication methods supported by
  # the AzureRM Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

subscription_id = "8209f557-e8fe-46ae-950e-dd13d0f21eca"
  tenant_id       = "85eb97a9-9b3a-450d-8531-f93c50de468b"
  client_id       = "c2a4d8db-e271-45d6-be28-f6eb743613a3"
  client_secret   = var.client_secret
}

terraform {
  backend "azurerm" {
    resource_group_name  = "tf_rg_blobstore_tf.file"
    storage_account_name = "storageaccounttfsta"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
variable "imagebuild" {
  type        = string
  description = "latest image build"
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
    image  = "stefancristianisit/aplicatieapi:${var.imagebuild}"
    cpu    = "1"
    memory = "1"

  ports {
      port     = 80
      protocol = "TCP"
    }
  }

}