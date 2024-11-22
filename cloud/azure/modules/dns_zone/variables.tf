variable "dns_zones" {
  description = "Map of resource groups to create, with details like name, location, and tags."
  type = map(object({
    name     = string
    resource_group_name = string
    tags     = map(string)
  }))
}
