
variable "virtual_networks" {
  description = "Map of virtual networks with their properties"
  type = map(object({
    name            = string
    address_space   = list(string)  # Use a list to define multiple address spaces if needed
    location            = string
    resource_group_name = string
    tags                = map(string)      # Map to hold tags as key-value pairs
  }))
}
