# environments/azure/_terragrunt/storage_account.hcl

locals {
  config   = yamldecode(file(find_in_parent_folders("config.yaml")))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.locals.env

  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  common_tags = local.common_vars.common_tags
}

# Storage Account module
terraform {
  source = "../../../../../cloud/azure/modules/storage_account"
}

# Dependency
dependency "resource_group" {
  config_path = "${get_terragrunt_dir()}/../resource_group"

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "apply", "destroy", "output"]
  skip_outputs                            = true
}

inputs = {
  storage_accounts = { for storage_acc in local.config.storage_accounts : storage_acc.name => {
    name                     = storage_acc.name
    resource_group_name      = storage_acc.resource_group_name
    location                 = storage_acc.location
    account_tier             = storage_acc.account_tier
    account_replication_type = storage_acc.account_replication_type
    tags                     = merge(local.common_tags, storage_acc.resource_tags)
    }
  }
}
