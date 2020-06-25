output "public_ip" {
  value = "${azurerm_public_ip.default.ip_address}"
}

output "fqdn" {
  value = "${azurerm_public_ip.default.fqdn}"
}