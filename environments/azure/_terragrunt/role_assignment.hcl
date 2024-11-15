# environments/azure/_terragrunt/role_assignment.hcl

locals {
  config   = yamldecode(file(find_in_parent_folders("config.yaml")))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.env_vars.locals.env

  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  common_tags = local.common_vars.common_tags
}

# Storage Account module
terraform {
  source = "../../../../../cloud/azure/modules/role_assignment"
}

# Dependency
dependency "resource_group" {
  config_path                            = "${get_terragrunt_dir()}/../resource_group"
  mock_outputs_merge_strategy_with_state = "deep_map_only"

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "apply", "destroy", "output"]
  mock_outputs = {
    resource_group_output = {
      "dummy-resource-group" = {
        id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/dummy-resource-group"
      }
    }
  }
}


inputs = {
  role_assignments = {
    for idx, role_assignment in flatten([
      for role_assignment in local.config.role_assignments : [
        for rg in role_assignment.resource_groups : {
          scope                = lookup(dependency.resource_group.outputs.resource_group_output, rg, { id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/mock-resource-group" }).id
          role_definition_name = role_assignment.role_definition_name
          principal_id         = role_assignment.principal_id
        }
      ]
    ]) : "${idx}" => role_assignment
  }
}


