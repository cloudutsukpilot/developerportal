variable "storage_accounts" {
  description = "The name of the storage accounts"
  type = map(object({
    name = string
    resource_group_name = string
    location = string
    account_tier = string
    account_replication_type = string
    tags = map(string)
  }))
}

