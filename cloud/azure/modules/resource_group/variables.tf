variable "resource_groups" {
  description = "Map of resource groups to create, with details like name, location, and tags."
  type = map(object({
    name     = string
    location = string
    tags     = map(string)
  }))
}

variable "common_tags" {
  description = "Common tags to apply to all resource groups"
  type        = map(string)
  default     = {}  # You can provide default tags if needed
}