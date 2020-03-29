provider "azurerm" {
    version = "=2.1.0"
    features {}
  }

resource "azurerm_resource_group" "rg" {
    name = "hrwrg"
    location = "eastus"
}

resource "azurerm_virtual_network" "vnet" {
    name                = "hrwnet"
    address_space       = ["10.10.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "Subnet10" {
    name                 = "Subnet10"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix       = "10.10.10.0/24"
}

resource "azurerm_subnet" "Subnet11" {
    name                 = "Subnet11"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix       = "10.10.11.0/24"
}