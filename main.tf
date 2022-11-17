terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.48.0"
    }
  }
}
provider "azurerm" {
  subscription_id = "cc81446f-0e40-4182-9e29-fd7186aaf416"
  tenant_id = "46c3cd01-059c-40e7-8df8-c42c11b9bc9e"
  features {}
}


resource "azurerm_resource_group" "rg" {
  name     = "WK_RG_AK"
  location = "West Europe"
}

resource "azurerm_container_registry" "acr" {
  name                = "wkacr129106"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "wkakscluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "wkakscluster"

  default_node_pool {
    name       = "default"
    node_count = "2"
    vm_size    = "standard_d2_v2"
  }
  identity {
    type = "SystemAssigned"
  }
  addon_profile {
    http_application_routing {
      enabled = true
    }
  }
}
