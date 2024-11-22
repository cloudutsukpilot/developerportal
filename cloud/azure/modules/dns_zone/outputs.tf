output "dns_zone_output" {
  description = "List of DNS Zones"
  value = { 
    for zone in azurerm_dns_zone.dns_zone : zone.name => {
      name     = zone.name
    }
  }
}