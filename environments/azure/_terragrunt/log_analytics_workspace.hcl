# environments/azure/_terragrunt/log_analytics_workspace.hcl

locals {
  config = yamldecode(file(find_in_parent_folders("config.yaml")))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.locals.env

  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  common_tags = local.common_vars.common_tags
}

# Resource Group module
terraform {
  source = "../../../../../cloud/azure/modules/log_analytics_workspace"
}

# Dependency
dependency "resource_group" {
  config_path = "${get_terragrunt_dir()}/../resource_group"

  mock_outputs_allowed_terraform_commands = ["init","validate","plan","apply","destroy","output"]
  skip_outputs = true
}

inputs = {
    workspaces = { for workspace in local.config.loganalyticsworkspaces : workspace.name => {
        name    = workspace.name
        location = workspace.location
        resource_group_name = workspace.resource_group_name
        sku = workspace.sku
        retention_in_days = workspace.retention_in_days
        tags = merge(local.common_tags, workspace.resource_tags) 
      }
    }
}
