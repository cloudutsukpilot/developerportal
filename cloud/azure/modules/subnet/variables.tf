variable "subnets" {
  description = "Map of subnets to create"
  type        = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
    service_endpoints     = list(string)
  }))
}