locals {
  config   = yamldecode(file(find_in_parent_folders("config.yaml")))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_tags = local.env_vars.inputs

  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  common_tags = local.common_vars.common_tags
}

# Resource Group module
terraform {
  source = "../../../../../cloud/azure/modules/resource_group"
}

inputs = {
  resource_groups = { for resource_group in local.config.resource_groups : resource_group.name => {
    name     = resource_group.name
    location = resource_group.location
    tags     = merge(local.common_tags, resource_group.resource_tags)
    }
  }
}