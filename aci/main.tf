# Define Azure provider
provider "azurerm" {
    version = "~> 2.14"
    features {}
}

# Defines Tags
locals {
  tags = {
    "project"     = var.baseName
    "environment" = var.environment
  }
}

# Define backend configuration with Azure storage for the tfstate file
terraform {
    backend "azurerm" {
        resource_group_name  = "#{commonRgName}#"
        storage_account_name = "#{depStraccName}#"
        container_name       = "#{depStrContName}#"
        key                  = "terraform.aci.tfstate"
        subscription_id      = "#{subscriptionId}#"
    }
}

# Create the resource group
resource "azurerm_resource_group" "main" {
    name     = "${var.baseName}-${var.environment}-${var.location}-rg"
    location = var.location
    tags     = local.tags
}

# Deploy Az Container Instance
resource "azurerm_container_group" "containergroup" {
  name                  = "${var.baseName}-${var.environment}-${var.location}-aci"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  ip_address_type       = "public"
  dns_name_label        = "${var.baseName}-${var.environment}-${var.location}-aci"
  os_type               = "Linux"

  container {
    name   = "${var.baseName}-${var.environment}-${var.location}"
    image  = "microsoft/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }
}