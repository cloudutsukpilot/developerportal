# environments/azure/_terragrunt/virtual_network.hcl

locals {
  config   = yamldecode(file(find_in_parent_folders("config.yaml")))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.inputs

  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  common_tags = local.common_vars.common_tags
}

# Resource Group module
terraform {
  source = "../../../../../cloud/azure/modules/virtual_network"
}

# Dependency
dependency "resource_group" {
  config_path = "${get_terragrunt_dir()}/../resource_group"

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "apply", "destroy", "output"]
  skip_outputs                            = true
}

inputs = {
  virtual_networks = try(
    { for vnet in local.config.virtual_networks : vnet.name => {
      name                = vnet.name
      address_space       = vnet.address_space
      location            = vnet.location
      resource_group_name = vnet.resource_group_name
      tags                = merge(local.common_tags, vnet.resource_tags)
      }
    },
    {}
  )
}
