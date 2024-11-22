
include "root" {
  path = find_in_parent_folders()
}

# Include the centralized configuration
include "dns_zone" {
  path   = "${dirname(find_in_parent_folders())}/_terragrunt/dns_zone.hcl"
  expose = true
}