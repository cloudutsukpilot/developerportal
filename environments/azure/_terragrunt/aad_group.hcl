locals {
  config   = yamldecode(file(find_in_parent_folders("config.yaml")))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_tags = local.env_vars.inputs

  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  common_tags = local.common_vars.common_tags
}

# Resource Group module
terraform {
  source = "../../../../../identity/entraid/modules/group"
}

inputs = {
  aad_groups = { for aad_group in local.config.aad_groups : aad_group.name => {
    display_name     = aad_group.display_name
    description      = aad_group.description
    owners           = aad_group.owners
    members          = aad_group.members
    security_enabled = aad_group.security_enabled
    }
  }
}