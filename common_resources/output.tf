output "kvName" {
    value = azurerm_key_vault.kv.name
}

output "baseName" {
    value = var.baseName
}

output "location" {
    value = var.location
}

output "environment" {
    value = var.environment
}

output "rgName" {
    value = azurerm_resource_group.main.name
}

output "straccName" {
    value = azurerm_storage_account.stracc.name
}

output "strContName" {
    value = azurerm_storage_container.strcont.name
}