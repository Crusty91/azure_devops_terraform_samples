output "dnsName" {
  value = azurerm_container_group.containergroup.fqdn
}