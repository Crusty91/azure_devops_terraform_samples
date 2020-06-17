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

# Define Backend
terraform {
    backend "local" {
        path  = "terraform.common.tfstate"
    }
}

# Define resource group
resource "azurerm_resource_group" "main" {
    name     = "${var.baseName}-${var.environment}-${var.location}-rg"
    location = var.location
    tags     = local.tags
}

# Define resources for tfstate
resource "azurerm_storage_account" "stracc" {
  name                     = "${var.baseName}${var.environment}str"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags                     = local.tags
}

resource "azurerm_storage_container" "strcont" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.stracc.name
  container_access_type = "private"
}

# Define resources for keyvault
resource "azurerm_key_vault" "kv" {
  name                              = "${var.baseName}${var.environment}${var.location}kv"
  location                          = azurerm_resource_group.main.location
  resource_group_name               = azurerm_resource_group.main.name
  sku_name                          = "standard"
  tenant_id                         = var.tenantId
  access_policy {
    tenant_id = var.tenantId
    object_id = var.objectId

    key_permissions = [
        "encrypt",
        "decrypt",
        "wrapKey",
        "unwrapKey",
        "sign",
        "verify",
        "get",
        "list",
        "create",
        "update",
        "import",
        "delete",
        "backup",
        "restore",
        "recover",
        "purge"
    ]

    secret_permissions = [
        "get",
        "list",
        "set",
        "delete",
        "backup",
        "restore",
        "recover",
        "purge"
    ]

    certificate_permissions = [
        "get",
        "list",
        "delete",
        "create",
        "import",
        "update",
        "managecontacts",
        "getissuers",
        "listissuers",
        "setissuers",
        "deleteissuers",
        "manageissuers",
        "recover",
        "purge"
    ]

    storage_permissions = [
        "get",
        "getsas",
        "list",
        "listsas",
        "set",
        "setsas",
        "delete",
        "deletesas",
        "backup",
        "restore",
        "recover",
        "purge",
        "regeneratekey",
        "update"
    ]
  }

  enabled_for_deployment            = true
  enabled_for_disk_encryption       = true
  enabled_for_template_deployment   = true
  network_acls {
    default_action                  = "Allow"
    bypass                          = "AzureServices"
  }

  purge_protection_enabled          = false
  soft_delete_enabled               = false

  tags                              = local.tags
}