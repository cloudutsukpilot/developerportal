variable "resource_groups" {
  description = "Map of resource group names and their locations."
  type        = map(string)
}

variable "tags" {
  description = "Map of tags for resource groups."
  type        = map(map(string))  # Map of maps for tags
}