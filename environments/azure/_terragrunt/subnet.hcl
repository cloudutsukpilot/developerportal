# environments/azure/_terragrunt/subnet.hcl

locals {
  config = yamldecode(file(find_in_parent_folders("config.yaml")))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.locals.env

  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  common_tags = local.common_vars.common_tags
}

# Resource Group module
terraform {
  source = "../../../../../cloud/azure/modules/subnet"
}

# Dependency
dependency "virtual_network" {
  config_path = "${get_terragrunt_dir()}/../virtual_network"

  mock_outputs_allowed_terraform_commands = ["init","validate","plan","apply","destroy","output"]
  skip_outputs = true
}

inputs = {
    subnets = { for subnet in local.config.subnets : subnet.name => {
        name    = subnet.name
        resource_group_name = subnet.resource_group_name
        virtual_network_name = subnet.virtual_network_name
        address_prefixes = subnet.address_prefixes     
        service_endpoints = subnet.service_endpoints
      }
    }
}
