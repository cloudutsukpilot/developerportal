variable "workspaces" {
  description = "Map of subnets to create"
  type        = map(object({
    name                 = string
    location             = string
    resource_group_name  = string
    sku                  = string
    retention_in_days    = number
  }))
}