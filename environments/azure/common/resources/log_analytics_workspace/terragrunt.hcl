# environments/azure/dev/backstage/log_analytics_workspace/terragrunt.hcl 

include {
  path = find_in_parent_folders()
}

# Include the centralized configuration
include "log_analytics_workspace" {
  path   = "${dirname(find_in_parent_folders())}/_terragrunt/log_analytics_workspace.hcl"
  expose = true
}
