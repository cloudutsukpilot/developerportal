# environments/azure/dev/terragrunt.hcl

include "root" {
  path = find_in_parent_folders()
}

# Include the centralized configuration
include "storage_account" {
  path   = "${dirname(find_in_parent_folders())}/_terragrunt/storage_account.hcl"
  expose = true
}
