# environments/azure/dev/terragrunt.hcl

include "root" {
  path = find_in_parent_folders()
}

# Include the centralized configuration
include "resource_group" {
  path   = "${dirname(find_in_parent_folders())}/_terragrunt/aad_group.hcl"
  expose = true
}