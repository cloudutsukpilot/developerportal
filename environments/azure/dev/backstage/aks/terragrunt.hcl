# environments/azure/dev/backstage/aks/terragrunt.hcl 

include {
  path = find_in_parent_folders()
}

# Include the centralized configuration
include "virtual_network" {
  path = "${dirname(find_in_parent_folders())}/_terragrunt/aks.hcl"
  expose = true
}
