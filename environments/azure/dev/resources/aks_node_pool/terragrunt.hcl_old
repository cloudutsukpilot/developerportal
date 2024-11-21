# environments/azure/dev/backstage/aks/terragrunt.hcl 

include {
  path = find_in_parent_folders()
}

# Include the centralized configuration
include "aks_node_pool" {
  path   = "${dirname(find_in_parent_folders())}/_terragrunt/aks_node_pool.hcl"
  expose = true
}
